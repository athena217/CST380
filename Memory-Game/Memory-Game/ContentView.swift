//
//  ContentView.swift
//  Memory-Game
//
//  Created by Athena Lopez on 3/3/26.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let content: String
    var isFaceUp = false
    var isMatched = false
}

struct ContentView: View {
    @State private var cards: [Card] = []
    @State private var firstSelectedIndex: Int? = nil
    @State private var numberOfPairs = 4

    var body: some View {
        VStack {
            Text("Memory Game")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .foregroundStyle(Color(red: 0.0, green: 0.30,blue: 0.18))
                
            Picker("Pairs", selection: $numberOfPairs) {
                Text("2 Pairs").tag(2)
                Text("4 Pairs").tag(4)
                Text("6 Pairs").tag(6)
                Text("8 Pairs").tag(8)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.45, green: 0.30,blue: 0.20))
            )
            .font(.headline)
            .padding(.horizontal)
            .onChange(of: numberOfPairs) {
                startGame()
            }
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(cards.indices, id: \.self) { index in
                        CardView(card: cards[index])
                            .onTapGesture {
                                handleTap(on: index)
                            }
                    }
                }
                .padding()
            }

            Button(action: startGame) {
                Text("Reset Game")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.0, green: 0.30,blue: 0.18))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

        }
        .onAppear { startGame() }
        .background(
            LinearGradient (
                colors: [
                    Color(red: 0.90, green: 0.98,blue: 0.92),
                    Color(red: 0.75, green: 0.90,blue: 0.80)
                    ],
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
        )
    }

    func startGame() {
        let emojis = ["🐼","🐻","🐶","🐱","🐨","🐵","🐙","🐳","🦭","🦉","🦦","🐥"]
        let chosen = Array(emojis.prefix(numberOfPairs))

        let pairCards = chosen.flatMap { emoji in
            [Card(content: emoji), Card(content: emoji)]
        }

        cards = pairCards.shuffled()
        firstSelectedIndex = nil
    }

    func handleTap(on index: Int) {
        if cards[index].isFaceUp || cards[index].isMatched { return }

        if let firstIndex = firstSelectedIndex {
            cards[index].isFaceUp = true

            if cards[firstIndex].content == cards[index].content {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    cards[firstIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                }
            }

            firstSelectedIndex = nil

        } else {
            cards[index].isFaceUp = true
            firstSelectedIndex = index
        }
    }
}

#Preview {
    ContentView()
}
