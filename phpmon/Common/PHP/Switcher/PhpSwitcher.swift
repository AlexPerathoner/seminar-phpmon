//
//  PhpVersionSwitchContract.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 24/12/2021.
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Foundation

protocol PhpSwitcherDelegate: AnyObject {

    func switcherDidStartSwitching(to version: String)

    func switcherDidCompleteSwitch(to version: String)

}

protocol PhpSwitcher {

    func performSwitch(to version: String) async

}
