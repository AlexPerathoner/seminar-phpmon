//
//  LocalNotification.swift
//  PHP Monitor
//
//  Copyright © 2023 Nico Verbruggen. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotification {

    @MainActor public static func send(title: String, subtitle: String, preference: PreferenceName?) {
        if preference != nil && !Preferences.isEnabled(preference!) {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(
            identifier: uuidString,
            content: content,
            trigger: nil
        )

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                Log.err(error!)
            }
        }
    }

}
