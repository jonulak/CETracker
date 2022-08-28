//
//  NABPCEImporter.swift
//  CETracker
//
//  Created by Jon Onulak on 7/25/22.
//

import Foundation
import WebKit
import CoreXLSX
import CoreData

class NABPCEImporter: NSObject {
    private enum ImportFlowStatus: Equatable {
        case loginPage
        case blankPage
        case dashboard
        case storePage
        case CPEMonitor
        case fileDownloading
        case importCEFromFile
        case error(ImportFlowError)
        
        var flowDescription: String? {
            switch self {
            case .loginPage, .blankPage:
                return "Authenticating"
            case .dashboard, .storePage, .CPEMonitor, .fileDownloading, .importCEFromFile:
                return "Importing"
            default:
                return nil
            }
        }
    }
    
    private enum ImportFlowError: Error, LocalizedError {
        case noUsernameEntered
        case noPasswordEntered
        case invalidLoginCredentials
        
        var errorDescription: String? {
            switch self {
            case .noUsernameEntered:
                return "No username was entered"
            case .noPasswordEntered:
                return "No password was entered"
            case .invalidLoginCredentials:
                return "Incorrect username or password was entered"
            }
        }
    }
    
    private var flowStatus: ImportFlowStatus = .loginPage
    private let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    private var CELogFileLocation: URL = {
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let fileURL = appSupportURL
            .appendingPathComponent("NABPImport" + String(Int.random(in: 10000...99999)))
            .appendingPathExtension("xlsx")
        return fileURL
    }()
    
    private var user: String!
    private var pass: String!
    
    override init() {
        super.init()        
        print(CELogFileLocation)
    }
    
    enum XLSXParserError: Error {
        case fileAccessError
        case parsedStrings
        case parsingWorkbooks
        case parsingWorksheetPathsAndNames
        case parseRows
    }
    
    func setLoginDetails(user: String, pass: String) {
        self.user = user
        self.pass = pass
    }
    
    private func parseXLSX(URL: URL, context: NSManagedObjectContext) throws -> [CECredit] {
        guard let file = XLSXFile(filepath: URL.path) else { throw XLSXParserError.fileAccessError }
        guard let sharedStrings = try file.parseSharedStrings() else { throw XLSXParserError.parsedStrings }
        guard let wbk = try file.parseWorkbooks().first else { throw XLSXParserError.parsingWorkbooks }
        guard let (_, path) = try file.parseWorksheetPathsAndNames(workbook: wbk).first else {
            throw XLSXParserError.parsingWorksheetPathsAndNames
        }
        let worksheet = try file.parseWorksheet(at: path)
        guard var rows = worksheet.data?.rows else { throw XLSXParserError.parseRows }
        let titleRow = rows.removeFirst()
        let columnHeaders = titleRow.cells.compactMap { $0.stringValue(sharedStrings) }
        let logProperties = columnHeaders.compactMap { CELogProperty(string: $0) }
        let credits = try rows.compactMap { row -> CECredit? in
            let cellContents = row.cells.compactMap { $0.stringValue(sharedStrings) }
            let keyValuePairs = zip(logProperties, cellContents)
            let keyedProperties = Dictionary(uniqueKeysWithValues: keyValuePairs)
            return try CECredit(creditProperties: keyedProperties, context: context)
        }
        return credits
    }
}

// MARK: - CEImporter
extension NABPCEImporter: CEImporter {
    var configViewController: CEImporterConfigViewController {
        let vc = NABPCEImporterConfigViewController()
        vc.importer = self
        return vc
    }
    
    func importCE(context: NSManagedObjectContext) async throws -> [CECredit] {
        let loginURLString = "https://sso.nabp.pharmacy/Account/Login"
        let loginURL = URL(string: loginURLString)!
        let request = URLRequest(url: loginURL)
        
        guard let user = user, !user.isEmpty else { throw ImportFlowError.noUsernameEntered }
        guard let pass = pass, !pass.isEmpty else { throw ImportFlowError.noPasswordEntered }
        
        let webView = await MainActor.run { () -> WKWebView in
            let webView = WKWebView()
            webView.navigationDelegate = self
            return webView
        }
            
        await webView.load(request)
        
        while flowStatus != .importCEFromFile {
            switch flowStatus {
            case .error(let error): throw error
            case .importCEFromFile: continue
            default: try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            }
        }
        let credits = try parseXLSX(URL: CELogFileLocation, context: context)
        try FileManager.default.removeItem(at: CELogFileLocation)
        return credits
    }
}



// MARK: - WKNavigationDelegate
// TODO:  Add timeouts, error checking/handling
extension NABPCEImporter: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch self.flowStatus {
        case .loginPage:
            guard let user = user, !user.isEmpty else {
                flowStatus = .error(ImportFlowError.noUsernameEntered)
                return
            }
            guard let pass = pass, !pass.isEmpty else {
                flowStatus = .error(ImportFlowError.noPasswordEntered)
                return
            }
            print("logging in")
            webView.evaluateJavaScript("document.getElementById('username').value='\(user)'")
            webView.evaluateJavaScript("document.getElementById('password').value='\(pass)'")
            flowStatus = .blankPage
            webView.evaluateJavaScript("document.getElementById('loginform').submit();")
        case .blankPage:
            print("nav to dash")
            // TODO:  Handle login errors here
            let dashboardURLString = "https://dashboard.nabp.pharmacy/#/dashboard/home"
            let dashboardURL = URL(string: dashboardURLString)!
            let request = URLRequest(url: dashboardURL)
            flowStatus = .dashboard
            webView.load(request)
        case .dashboard:
            print("load CPE monitor")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                webView.evaluateJavaScript("document.getElementsByTagName('mat-card')[0].innerHTML") { value, error in
                    if error == nil {
                        timer.invalidate()
                        webView.evaluateJavaScript("document.getElementsByTagName('mat-card')[0].click();")
                        self.flowStatus = .CPEMonitor
                    }
                }
            }
        case .CPEMonitor:
            print("download log")
            self.flowStatus = .fileDownloading
            let CSVURLString = "https://ind.nabp.pharmacy/CpeMonitor/ExportToExcel?startDate=07%2F22%2F2018&endDate=07%2F22%2F2022"
            let CSVURL = URL(string: CSVURLString)!
            let request = URLRequest(url: CSVURL)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                print("timer running")
                webView.evaluateJavaScript("document.getElementById('dropdownMenuButton').innerHTML") { value, error in
                    if error == nil {
                        timer.invalidate()
                        webView.startDownload(using: request) { download in
                            download.delegate = self
                        }
                    }
                }
            }
        default: break
        }
    }
}


// MARK: - WKDownloadDelegate
extension NABPCEImporter: WKDownloadDelegate {
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        print("save file")
        try? FileManager.default.removeItem(at: CELogFileLocation)
        try? FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true, attributes: nil)
        completionHandler(CELogFileLocation)
    }

    func downloadDidFinish(_ download: WKDownload) {
        print("download finished")
        self.flowStatus = .importCEFromFile
    }
}
