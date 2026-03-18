//
//  FirestoreService.swift
//  Project6-TranslateMe
//
//  Created by Athena Lopez on 3/17/26.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class FirestoreService {
    private let db = Firestore.firestore()
    
    func save(_ translation: Translation) {
        db.collection("translations")
          .document(translation.id)
          .setData([
            "original": translation.original,
            "translated": translation.translated,
            "timestamp": translation.timestamp
          ])
    }
    
    func listenToHistory(completion: @escaping ([Translation]) -> Void) {
        db.collection("translations")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let items: [Translation] = documents.compactMap { doc in
                    let data = doc.data()
                    
                    return Translation(
                        id: doc.documentID,
                        original: data["original"] as? String ?? "",
                        translated: data["translated"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    )
                }
                
                completion(items)
            }
    }
    
    func deleteAll() {
        db.collection("translations").getDocuments { snapshot, _ in
            snapshot?.documents.forEach { $0.reference.delete() }
        }
    }
}
