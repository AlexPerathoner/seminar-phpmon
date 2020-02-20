//
//  PhpVersionExtractor.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 11/06/2019.
//  Copyright © 2019 Nico Verbruggen. All rights reserved.
//

import Foundation

class PhpVersion {
    
    var short : String = "???"
    var long : String = "???"
    
    var xdebugFound: Bool = false
    var xdebugEnabled : Bool = false
    
    init() {
        let version = Command.execute(path: "/usr/local/bin/php", arguments: ["-r", "print phpversion();"])
        
        // That's the long version
        self.long = version
        
        // Next up, let's strip away the minor version number
        let segments = long.components(separatedBy: ".")
        
        // Get the first two elements
        self.short = segments[0...1].joined(separator: ".")
        
        // Load xdebug support
        self.xdebugFound = Actions.XdebugFound(self.short)
        if (self.xdebugFound) {
            self.xdebugEnabled = Actions.XdebugEnabled(self.short)
        }
    }
}