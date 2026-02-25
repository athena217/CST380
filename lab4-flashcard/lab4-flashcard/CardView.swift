//
//  CardView.swift
//  lab4-flashcard
//
//  Created by Athena Lopez on 2/24/26.
//

import Foundation
import SwiftUI

struct Card: Equatable {
    let question: String
    let answer: String
    
    static let mockedCards = [
            Card(question: "Located at the southern end of Puget Sound, what is the capitol of Washington?", answer: "Olympia"),
            Card(question: "Which city serves as the capital of Texas?", answer: "Austin"),
            Card(question: "What is the capital of New York?", answer: "Albany"),
            Card(question: "Which city is the capital of Florida?", answer: "Tallahassee"),
            Card(question: "What is the capital of Colorado?", answer: "Denver")
        ]
}

struct CardView: View {
    let card: Card
    var onSwipedLeft: (() -> Void)?
    var onSwipedRight: (() -> Void)?
    
    private let swipeThreshold: Double = 200
    
    @State private var isShowingQuestion = true
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)                        .fill(offset.width < 0 ? .red : .green)
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(isShowingQuestion ? Color.blue.gradient : Color.indigo.gradient)
                    .shadow(color: .black, radius: 4, x: -2, y: 2)
                    .opacity(1 - abs(offset.width) / swipeThreshold)
            }
            VStack(spacing: 20) {
                Text(isShowingQuestion ? "Question" : "Answer")
                    .bold()
                Rectangle()
                    .frame(height: 1)
                Text(isShowingQuestion ? card.question : card.answer)
                //Text("Located at the southern end of Puget Sound, what is the capitol of Washington?")
            }
            .font(.title)
            .foregroundStyle(.white)
            .padding(40)
        }
        .frame(width: 300, height: 500)
        .onTapGesture {
            isShowingQuestion.toggle()
        }
        .opacity(3 - abs(offset.width) / swipeThreshold * 3)
        .rotationEffect(.degrees(offset.width / 20.0))
        .offset(CGSize(width: offset.width, height: 0))
        .gesture(DragGesture()
            .onChanged { gesture in
                let translation = gesture.translation
                print(translation)
                offset = translation
            }.onEnded { gesture in
                if gesture.translation.width > swipeThreshold {   print("👉 Swiped right")
                    onSwipedRight?()
                } else if gesture.translation.width < -swipeThreshold
                {
                    print("👈 Swiped left")
                    onSwipedLeft?()
                } else {
                    print("🚫 Swipe canceled")
                    withAnimation(.bouncy) {                        offset = .zero
                    }
                }
            }
        )
    }
}

#Preview {
    CardView(card: Card(
            question: "Located at the southern end of Puget Sound, what is the capitol of Washington?",
            answer: "Olympia"))
}


