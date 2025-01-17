//
//  MainMenuBuilder.swift
//  PHP Monitor
//
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Cocoa

class StatusMenu: NSMenu {
    // swiftlint:disable cyclomatic_complexity
    func addMenuItems() {
        addPhpVersionMenuItems()
        addItem(NSMenuItem.separator())

        if PhpEnvironments.phpInstall != nil && Preferences.isEnabled(.displayGlobalVersionSwitcher) {
            addPhpActionMenuItems()
            addItem(NSMenuItem.separator())
        }

        if PhpEnvironments.phpInstall != nil && Valet.installed && Preferences.isEnabled(.displayServicesManager) {
            addServicesManagerMenuItem()
            addItem(NSMenuItem.separator())
        }

        if Valet.shared.version != nil && Preferences.isEnabled(.displayValetIntegration) {
            addValetMenuItems()
            addItem(NSMenuItem.separator())
        }

        if PhpEnvironments.phpInstall != nil && Preferences.isEnabled(.displayPhpConfigFinder) {
            addConfigurationMenuItems()
            addItem(NSMenuItem.separator())
        }

        if PhpEnvironments.phpInstall != nil && Preferences.isEnabled(.displayComposerToolkit) {
            addComposerMenuItems()
            addItem(NSMenuItem.separator())
        }

        if !PhpEnvironments.shared.isBusy {
            if PhpEnvironments.phpInstall != nil && Preferences.isEnabled(.displayLimitsWidget) {
                addStatsMenuItem()
                addItem(NSMenuItem.separator())
            }

            if PhpEnvironments.phpInstall != nil && Preferences.isEnabled(.displayExtensions) {
                addExtensionsMenuItems()
                NSMenuItem.separator()

                addXdebugMenuItem()
            }

            addPhpDoctorMenuItem()

            if PhpEnvironments.phpInstall != nil && Preferences.isEnabled(.displayPresets) {
                addPresetsMenuItem()
            }

            if PhpEnvironments.phpInstall != nil && Preferences.isEnabled(.displayMisc) {
                addFirstAidAndServicesMenuItems()
            }
        }

        addItem(NSMenuItem.separator())

        addPreferencesMenuItems()

        if !Valet.installed {
            addLiteModeMenuItem()
        }

        addCoreMenuItems()
    }
    // swiftlint:enable cyclomatic_complexity
}
