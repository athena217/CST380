//
//  FireChatApp.swift
//  FireChat
//
//  Created by Athena Lopez on 3/10/26.
//

import SwiftUI
import FirebaseCore

@main
struct FireChatApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
