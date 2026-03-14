//
//  TriviaAPI.swift
//  Project5-TriviaGame
//
//  Created by Athena Lopez on 3/13/26.
//

import Foundation
import SwiftUI

class TriviaAPI {
    func fetchTrivia(amount: Int,
                     category: Int,
                     difficulty: String,
                     type: String) async throws -> [TriviaQuestion] {
        var urlString = "https://opentdb.com/api.php?amount=\(amount)"
        
        if category != 0 {
            urlString += "&category=\(category)"
        }
        
        if difficulty != "any" {
            urlString += "&difficulty=\(difficulty)"
        }
        
        if type != "any" {
            urlString += "&type=\(type)"
        }
        
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
        
        return decoded.results
    }
}

