//
//  ValetProxy.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 30/03/2022.
//  Copyright © 2022 Nico Verbruggen. All rights reserved.
//

import Foundation

class ValetProxy: DomainListable
{
    var domain: String
    var tld: String
    var target: String
    
    init(_ configuration: NginxConfiguration) {
        self.domain = configuration.domain
        self.tld = configuration.tld
        self.target = configuration.proxy!
    }
    
    // MARK: - DomainListable Protocol
    
    func getListableName() -> String {
        return self.domain
    }
    
    func getListableSecured() -> Bool {
        return false
    }
    
    func getListableAbsolutePath() -> String {
        return self.domain
    }
    
    func getListablePhpVersion() -> String {
        return ""
    }
    
    func getListableKind() -> String {
        return "proxy"
    }
    
    func getListableType() -> String {
        return "proxy"
    }
}
