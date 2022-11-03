//
//  NestedTableView.swift
//  CETracker
//
//  Created by Jon Onulak on 8/2/22.
//

import Foundation

import UIKit

class NestedTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}
