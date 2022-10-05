//
//  Editor.swift
//  PHP Monitor
//
//  Created by Nico Verbruggen on 07/12/2021.
//  Copyright © 2022 Nico Verbruggen. All rights reserved.
//

import Foundation

/// An application that is capable of opening a particular directory (usually of a PHP project).
/// In most cases this is going to be a code editor, but it could also be another application
/// that supports opening those directories, like a visual Git client or a terminal app.
class Application {

    enum AppType {
        case editor, browser, git_gui, terminal, user_supplied
    }

    /// Name of the app. Used for display purposes and to determine `name.app` exists.
    let name: String

    /// Application type. Depending on the type, a different action might occur.
    let type: AppType

    /// Initializer. Used to detect a specific app of a specific type.
    init(_ name: String, _ type: AppType) {
        self.name = name
        self.type = type
    }

    /**
     Attempt to open a specific directory in the app of choice.
     (This will open the app if it isn't open yet.)
     */
    @objc public func openDirectory(file: String) async {
        return await Shell.quiet("/usr/bin/open -a \"\(name)\" \"\(file)\"")
    }

    /** Checks if the app is installed. */
    func isInstalled() async -> Bool {

        let (process, output) = try! await Shell.attach(
            "/usr/bin/open -Ra \"\(name)\"",
            didReceiveOutput: { _, _ in },
            withTimeout: 2.0
        )

        if Shell is TestableShell {
            // When testing, check the error output (must not be empty)
            return !output.hasError
        } else {
            // If this script does not complain, the app exists!
            return process.terminationStatus == 0
        }
    }

    /**
     Detect which apps are available to open a specific directory.
     */
    static public func detectPresetApplications() async -> [Application] {
        var detected: [Application] = []

        let detectable = [
            Application("PhpStorm", .editor),
            Application("Visual Studio Code", .editor),
            Application("Sublime Text", .editor),
            Application("Sublime Merge", .git_gui),
            Application("iTerm", .terminal)
        ]

        for app in detectable where await app.isInstalled() {
            detected.append(app)
        }

        return detected
    }
}
