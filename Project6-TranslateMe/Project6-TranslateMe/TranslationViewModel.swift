//
//  TranslationViewModel.swift
//  Project6-TranslateMe
//
//  Created by Athena Lopez on 3/17/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class TranslationViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var outputText = ""
    @Published var history: [Translation] = []
    
    @Published var sourceLanguage = "en"
    @Published var targetLanguage = "es"
    
    let languages = [
            "en": "English",
            "es": "Spanish",
            "fr": "French",
            "de": "German",
            "it": "Italian",
            "ja": "Japanese"
        ]
    
    private let api = MyMemoryAPI()
    private let firestore = FirestoreService()
    
    init() {
        firestore.listenToHistory { [weak self] items in
            self?.history = items
        }
    }
    
    func translate() async {
        guard !inputText.isEmpty else { return }
        
        do {
            let result = try await api.translate(
                            text: inputText,
                            from: sourceLanguage,
                            to: targetLanguage
                        )
            outputText = result
            
            let translation = Translation(
                id: UUID().uuidString,
                original: inputText,
                translated: result,
                timestamp: Date()
            )
            
            firestore.save(translation)
            
        } catch {
            print("Translation failed:", error)
        }
    }
    
    func clearHistory() {
        firestore.deleteAll()
    }
}
