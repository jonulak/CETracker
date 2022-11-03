//
//  TableChange.swift
//  CETracker
//
//  Created by Jon Onulak on 8/25/22.
//

import Foundation

typealias TableViewChange = (TableChangeType, [IndexPath])

enum TableChangeType {
    case addition
    case deletion
    case edit
}
