//
//  CardView.swift
//  Memory-Game
//
//  Created by Athena Lopez on 3/3/26.
//

import Foundation
import SwiftUI


struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            if card.isMatched {
                Color.clear
            } else if card.isFaceUp {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green, lineWidth: 3)
                    )
                Text(card.content)
                    .font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.0, green: 0.30,blue: 0.18))
            }
        }
        .frame(height: 100)
        .shadow(radius: 3)
        
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 100),
            axis: (x: 1, y: 0, z: 0)
        )
        .animation(.easeOut(duration: 0.3), value: card.isFaceUp)
    }
}
