//
//  ContentView.swift
//  lab4-flashcard
//
//  Created by Athena Lopez on 2/24/26.
//

import SwiftUI

struct ContentView: View {
    @State private var cards: [Card] = Card.mockedCards
    @State private var cardsToPractice: [Card] = []
    @State private var cardsMemorized: [Card] = []
    @State private var deckId: Int = 0
    @State private var createCardViewPresented = false

    var body: some View {
        ZStack {
            VStack {
                Button("Reset") {
                    cards = cardsToPractice + cardsMemorized
                    cardsToPractice = []
                    cardsMemorized = []
                    deckId += 1
                }
                .disabled(cardsToPractice.isEmpty && cardsMemorized.isEmpty)
                
                Button("More Practice") {
                    cards = cardsToPractice
                    cardsMemorized = []
                    deckId += 1
                }
                .disabled(cardsToPractice.isEmpty)
            }
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(card: cards[index],
                onSwipedLeft: {
                    let removedCard = cards.remove(at: index)
                    cardsToPractice.append(removedCard)
                }, onSwipedRight: {
                    let removedCard = cards.remove(at: index)
                    cardsMemorized.append(removedCard)
                })
                .rotationEffect(.degrees(Double(cards.count - 1 - index) * -5))
            }
        }
        .id(deckId)
        .sheet(isPresented: $createCardViewPresented, content: {
            CreateFlashcardView { card in
                    cards.append(card)
                }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            Button("Add Flashcard", systemImage: "plus") {             createCardViewPresented.toggle()
            }
            .padding()
        }
        .animation(.bouncy, value: cards)
    }
}

struct NicoView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
