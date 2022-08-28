//
//  ViewController.swift
//  CETracker
//
//  Created by Jon Onulak on 5/30/22.
//

import UIKit
import Combine

class CELogViewController: UIViewController {
    
    @IBOutlet weak var creditLogTableView: UITableView!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var viewModel: CELogViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = CELogViewModel(model: CELogModel(context: context))
        
        creditLogTableView.dataSource = self
        creditLogTableView.register(UINib(nibName: "CECreditCell", bundle: nil), forCellReuseIdentifier: "ReusableCreditCell")
    }
    
    @IBAction func importPressed(_ sender: UIBarButtonItem) {
//        let importer = NABPCEImporter()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        let NABPImportAction = UIAlertAction(title: "Import From NABP", style: .default) { _ in
            self.importFrom(importer: NABPCEImporter())
        }
        alertController.addAction(NABPImportAction)
        
        let manualAddAction = UIAlertAction(title: "Manual Entry", style: .default, handler: nil)
        alertController.addAction(manualAddAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func importFrom(importer: CEImporter) {
        let importerViewController = importer.configViewController
        importerViewController.delegate = self
        present(importerViewController, animated: true)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        let changes = viewModel.clearCredits()
//        creditLogTableView.reloadData()
        creditLogTableView.animateUpdates(changes: changes)
    }
}

extension CELogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.credits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCreditCell", for: indexPath) as! CECreditCell
        let credit = viewModel.credits[indexPath.row]
        cell.titleLabel.text = credit.title
        cell.topicLabel.text = credit.topicDesignator.topicDesignatorTitle
        cell.cellBubble.backgroundColor = viewModel.getCellColorFor(topic: credit.topicDesignator)
        cell.hoursLabel.text = viewModel.hoursLabel(for: credit)
        cell.dateLabel.text = viewModel.dateLabel(for: credit)
        return cell
    }
}

extension CELogViewController: CEImporterDelegate {
    
    func configDidComplete(for importer: CEImporter) {
        dismiss(animated: true)
        Task {
            do {
                let changes = try await viewModel.importCE(from: importer)
                creditLogTableView.animateUpdates(changes: changes)
            } catch {
                let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }
        }
    }
}

