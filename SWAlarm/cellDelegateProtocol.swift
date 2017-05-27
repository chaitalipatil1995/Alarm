//
//  cellDelegateProtocol.swift
//  SWAlarm
//
//  Created by Amesten Systems on 26/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import Foundation

protocol cellDelegateProtocol: class {
    func didPressButton(_ tag: NSInteger)
}

class SomeClass {
    weak var delegate: cellDelegateProtocol?
}
