//
//  ChatView.swift
//  FireChat
//
//  Created by Athena Lopez on 3/11/26.
//

import Foundation
import SwiftUI

struct ChatView: View {
    @Environment(AuthManager.self) var authManager
    @State var messageManager: MessageManager

    init(isMocked: Bool = false) {
        messageManager = MessageManager(isMocked: isMocked)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(messageManager.messages) { message in
                        Text(message.text)
                    }
                }
            }
            Text("Welcome to FireChat!")
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button("Sign out") {
                            authManager.signOut()
                        }
                    }
                }
        }
    }
}

#Preview {
    ChatView(isMocked: true)
        .environment(AuthManager(isMocked: true))
}
