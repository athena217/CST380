//
//  HistoryView.swift
//  Project6-TranslateMe
//
//  Created by Athena Lopez on 3/17/26.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @ObservedObject var vm: TranslationViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Saved Translations")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    vm.clearHistory()
                }) {
                    Text("Clear")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.green.opacity(0.6))
                        .cornerRadius(8)
                }
            }
            .padding()
            
            ScrollView {
                LazyVStack(spacing: 10) {
                    if vm.history.isEmpty {
                        Text("No translations yet")
                            .foregroundColor(.gray.opacity(0.8))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.3))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    } else {
                        ForEach(vm.history) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.original)
                                    .bold()
                                    .foregroundColor(.white)
                                Text(item.translated)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding()
                            .background(Color.green.opacity(0.4))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .background(
            LinearGradient(
                colors: [Color.green.darker(), Color.green.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

extension Color {
    func darkGreen(amount: Double = 0.7) -> Color {
        return self.opacity(1.0 - amount)
    }
}
