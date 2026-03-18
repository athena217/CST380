//
//  Project6_TranslateMeApp.swift
//  Project6-TranslateMe
//
//  Created by Athena Lopez on 3/17/26.
//

import SwiftUI
import FirebaseCore

@main
struct Project6_TranslateMeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
