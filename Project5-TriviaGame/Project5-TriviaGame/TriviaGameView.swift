//
//  TriviaGameView.swift
//  Project5-TriviaGame
//
//  Created by Athena Lopez on 3/12/26.
//

import Foundation
import SwiftUI

struct TriviaGameView: View {
    let amount: Int
    let category: Int
    let difficulty: String
    let type: String
    let timer: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("Trivia Game")
                .font(.largeTitle.bold())

            Text("Questions: \(amount)")
            Text("Category ID: \(category)")
            Text("Difficulty: \(difficulty.capitalized)")
            Text("Type: \(type)")
            Text("Timer: \(timer) seconds")

            Spacer()
        }
        .padding()
        .navigationTitle("Trivia Game")
    }
}

#Preview {
TriviaGameView(
        amount: 10,
        category: 9,
        difficulty: "easy",
        type: "multiple",
        timer: 30
    )
}

