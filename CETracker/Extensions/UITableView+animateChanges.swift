//
//  UITableView+animateChanges.swift
//  CETracker
//
//  Created by Jon Onulak on 8/25/22.
//

import Foundation
import UIKit

extension UITableView {
    func animateUpdates(changes: [TableViewChange]) {
        beginUpdates()
        changes.forEach { (changeType, indexPaths) in
            switch changeType {
            case .addition:
                insertRows(at: indexPaths, with: .fade)
            case .deletion:
                deleteRows(at: indexPaths, with: .fade)
            default:
                break
            }
        }
        endUpdates()
    }

    func animateUpdates(changes: TableViewChange) {
        animateUpdates(changes: [changes])
    }
}
