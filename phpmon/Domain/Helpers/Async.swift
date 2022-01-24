//
//  Async.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 23/01/2022.
//  Copyright © 2022 Nico Verbruggen. All rights reserved.
//

import Foundation

public func runAsync(_ execute: @escaping () -> Void, completion: @escaping () -> Void = {})
{
    DispatchQueue.global(qos: .userInitiated).async {
        execute()
        
        DispatchQueue.main.async {
            completion()
        }
    }
}
