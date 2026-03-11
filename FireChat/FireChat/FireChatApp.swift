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
    @State private var authManager: AuthManager

    init() {
        FirebaseApp.configure()
        authManager = AuthManager()
    }

    var body: some Scene {
        WindowGroup {
            if authManager.user != nil {
                ChatView()
                    .environment(authManager)
            } else {
                LoginView()
                    .environment(authManager)
            }
        }
    }
}
