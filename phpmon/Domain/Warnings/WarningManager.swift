//
//  WarningManager.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 09/08/2022.
//  Copyright © 2022 Nico Verbruggen. All rights reserved.
//

import Foundation

class WarningManager {

    static var shared = WarningManager()

    public let evaluations: [Warning] = [
        Warning(
            command: {
                return Shell.pipe("sysctl -n sysctl.proc_translated")
                    .trimmingCharacters(in: .whitespacesAndNewlines) == "1"
            },
            name: "Running PHP Monitor with Rosetta on M1",
            titleText: "warnings.arm_compatibility.title",
            descriptionText: "warnings.arm_compatibility.description",
            url: nil
        )
    ]

    @Published public var warnings: [Warning] = []

    public func hasWarnings() -> Bool {
        return !warnings.isEmpty
    }

    func evaluateWarnings() {
        Task { await WarningManager.shared.checkEnvironment() }
    }

    /**
     Checks the user's environment and checks if any special warnings apply.
     */
    func checkEnvironment() async {
        self.warnings = []
        for check in self.evaluations {
            if await check.applies() {
                Log.info("[WARNING] \(check.name)")
                self.warnings.append(check)
                continue
            }
        }
    }

}
