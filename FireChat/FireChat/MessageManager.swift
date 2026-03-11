//
//  MessageManager.swift
//  FireChat
//
//  Created by Athena Lopez on 3/11/26.
//

import Foundation
import FirebaseFirestore

@Observable
class MessageManager {

    var messages: [Message] = []

    init(isMocked: Bool = false) {
        if isMocked {
            messages = Message.mockedMessages
        } else {
            // TODO: Fetch messages from Firestore database

        }
    }

    // TODO: Save message

    // TODO: Get messages

}
