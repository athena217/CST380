//
//  NotificationManager.swift
//  BeReal

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
                self.scheduleReminder()
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func scheduleReminder() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to BeReal!"
        content.body = "Share what you're doing right now 📸"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                
        let request = UNNotificationRequest(identifier: "postReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled!")
            }
        }
    }
    
    func cancelReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Notifications cancelled")
    }
}



