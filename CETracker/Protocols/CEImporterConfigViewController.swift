//
//  CEImporterConfigViewController.swift
//  CETracker
//
//  Created by Jon Onulak on 9/9/22.
//

import Foundation
import UIKit

protocol CEImporterConfigViewController: UIViewController {
    var delegate: CEImporterDelegate? { get set }
}
