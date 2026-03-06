//
//  AppDelegate.swift
//  BeReal
//

import UIKit
import ParseSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

            // https://github.com/parse-community/Parse-Swift/blob/main/ParseSwift.playground/Sources/Common.swift
        ParseSwift.initialize(applicationId: "XpBpDRZF3bMrehuGg3JPGYiCOnvNg5xHiZMjOzXL",
                              clientKey: "9TGj2d1JjW504Xbxk1cux8FKtIUjsx2k0ufCq9Ly",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)

        UNUserNotificationCenter.current().delegate = self
        
        return true
    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound])
    }
}

