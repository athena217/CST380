//
//  ContentView.swift
//  Project5-TriviaGame
//
//  Created by Athena Lopez on 3/12/26.
//

import SwiftUI
struct ContentView: View {
    @State private var numberOfQuestions = 10
    @State private var selectedCategory = 9
    @State private var selectedDifficulty = "easy"
    @State private var selectedType = "any"
    @State private var selectedTimer = 30

    let categories = [
        (9, "General Knowledge"),
        (17, "Science"),
        (18, "Computers"),
        (23, "History"),
        (21, "Sports"),
        (22, "Geography")
    ]
    
    let questionTypes = [
        ("any", "Any"),
        ("multiple", "Multiple Choice"),
        ("boolean", "True/False")
    ]
    
    let timerOptions = [
        10, 30, 60, 120, 300, 3600
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Trivia Game")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)
                Form {
                    Section(header: Text("Number of Questions")) {
                        Stepper(value: $numberOfQuestions, in: 5...20) {
                            Text("\(numberOfQuestions)")
                                .font(.headline)
            }
                    }
                    
                    // Category Picker
                    Section(header: Text("Category")) {
                        Picker("Select Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.0) { category in
                                Text(category.1).tag(category.0)
                            }
                        }
                    }
                    // Difficulty Picker
                    Section(header: Text("Difficulty")) {
                        Picker("Difficulty", selection: $selectedDifficulty) {
                            Text("Easy").tag("easy")
                            Text("Medium").tag("medium")
                            Text("Hard").tag("hard")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Type Picker
                    Section(header: Text("Question Type")) {
                        Picker("Type", selection: $selectedType) {
                            ForEach(questionTypes, id: \.0) { type in
                                Text(type.1).tag(type.0)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Timer
                    Section(header: Text("Timer Duration")) {
                        Picker("Timer", selection: $selectedTimer) {
                            ForEach(timerOptions, id: \.self) { time in
                                Text(formatTime(time)).tag(time)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
                // Start Game Button
                NavigationLink(destination:
                                TriviaGameView(
                                    amount: numberOfQuestions,
                                    category: selectedCategory,
                                    difficulty: selectedDifficulty,
                                    type: selectedType,
                                    timer: selectedTimer
                                )
                ) {
                    Text("Start Game")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
    func formatTime(_ seconds: Int) -> String {
        switch seconds {
        case 10: return "10 seconds"
        case 30: return "30 seconds"
        case 60: return "1 minute"
        case 120: return "2 minutes"
        case 300: return "5 minutes"
        case 3600: return "1 hour"
        default: return "\(seconds) sec"

        }
    }
}

#Preview {
    ContentView()
}
