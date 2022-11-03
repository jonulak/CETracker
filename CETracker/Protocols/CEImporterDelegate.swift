//
//  CEImporterDelegate.swift
//  CETracker
//
//  Created by Jon Onulak on 9/9/22.
//

import Foundation

protocol CEImporterDelegate: AnyObject {
    func configDidComplete(for importer: CEImporter)
}
