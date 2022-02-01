//
//  main.swift
//  phpmon-cli
//
//  Created by Nico Verbruggen on 20/12/2021.
//  Copyright © 2021 Nico Verbruggen. All rights reserved.
//

import Foundation

let toolver = "0.1 (early access)"

let log = Log.shared
log.verbosity = .info

if CommandLine.arguments.contains("-q") || CommandLine.arguments.contains("--quiet") {
    Log.shared.verbosity = .warning
}
if CommandLine.arguments.contains("-p") || CommandLine.arguments.contains("--performance") {
    Log.shared.verbosity = .performance
}

var argument = "help"
if CommandLine.arguments.count > 1 {
    argument = CommandLine.arguments[1]
}

if !AllowedArguments.has(argument) {
    Log.err("The supported arguments are: \(AllowedArguments.rawValues)")
    exit(1)
}

let action = AllowedArguments.init(rawValue: argument)

switch action {
case .use, .performSwitch:
    if !Shell.fileExists("\(Paths.binPath)/php") {
        Log.err("PHP is currently not linked. Attempting quick fix...")
        _ = Shell.user.executeSynchronously("brew link php", requiresPath: true)
    }
    
    let phpenv = PhpEnv.shared
    PhpEnv.detectPhpVersions()
    
    if CommandLine.arguments.count < 3 {
        Log.err("You must enter at least two additional arguments when using this command.")
        exit(1)
    }
    
    let version = CommandLine.arguments[2].replacingOccurrences(of: "php@", with: "")
    if phpenv.availablePhpVersions.contains(version) {
        Log.info("Switching to PHP \(version)...")
        Actions.switchToPhpVersion(
            version: version,
            availableVersions: phpenv.availablePhpVersions,
            completed: {
                Log.info("The switch has been completed.")
                exit(0)
            }
        )
    } else {
        Log.err("A PHP installation with version \(version) is not installed.")
        Log.err("The installed versions are: \(phpenv.availablePhpVersions.joined(separator: ", ")).")
        Log.err("If this version is available, you may be able to install it by using `brew install php@\(version)`.")
        exit(1)
    }
case .fix:
    Log.info("Fixing your PHP installation...")
    Actions.fixMyPhp()
    Log.info("All operations completed. You can check which version of PHP is linked by using `php -v`.")
    exit(0)
case .help:
    print("""
    ===============================================================
    PHP MONITOR CLI \(toolver)
    by Nico Verbruggen
    ===============================================================
    
    Gives access to the quick version switcher from PHP Monitor,
    but without the GUI and 100% of the speed!
    
    SUPPORTED COMMANDS
    
    * use {version}:      Switch to a specific version of PHP.
                          (e.g. `phpmon-cli use 8.0`)
    * switch {version}:   Alias for the `use` command.
    * fix                 Attempts to unlink all PHP versions,
                          and link the latest version of PHP.
    * help:               Show this help.
    
    SUPPORTED FLAGS
    
    * `-q / --quiet`:     Silences all logs except for warnings and exceptions.
    * `-p / --perf`:      Enables performance mode.
    
    """)
    exit(0)
case .none:
    Log.err("Action not recognized!")
    exit(1)
}

RunLoop.main.run()
