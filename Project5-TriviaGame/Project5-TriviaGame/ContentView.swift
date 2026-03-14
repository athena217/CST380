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
        (27, "Animals"),
        (25, "Art"),
        (32, "Cartoons & Animations"),
        (18, "Computers"),
        (22, "Geography"),
        (23, "History"),
        (12, "Music"),
        (17, "Science"),
        (21, "Sports"),
        (15, "Video Games")
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

            ZStack {
                Color(red: 0.88, green: 0.95, blue: 0.88)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Trivia Game")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.2))
                        .padding(.top, 20)

                    Form {
                        Section(header:
                            Text("Number of Questions")
                                .foregroundColor(.black)
                        ) {
                            Stepper(value: $numberOfQuestions, in: 5...20) {
                                Text("\(numberOfQuestions)")
                                    .font(.headline)
                            }
                        }
                        Section(header:
                            Text("Category")
                                .foregroundColor(.black)
                        ) {
                            Picker("Select Category", selection: $selectedCategory) {
                                ForEach(categories, id: \.0) { category in
                                    Text(category.1).tag(category.0)
                                }
                            }
                        }
                        Section(header:
                            Text("Difficulty")
                                .foregroundColor(.black)
                        ) {
                            Picker("Difficulty", selection: $selectedDifficulty) {
                                Text("Easy").tag("easy")
                                Text("Medium").tag("medium")
                                Text("Hard").tag("hard")
                            }
                            .pickerStyle(.segmented)
                        }

                        Section(header:
                            Text("Question Type")
                                .foregroundColor(.black)
                        ) {
                            Picker("Type", selection: $selectedType) {
                                ForEach(questionTypes, id: \.0) { type in
                                    Text(type.1).tag(type.0)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        Section(header:
                            Text("Timer Duration")
                                .foregroundColor(.black)
                        ) {
                            Picker("Timer", selection: $selectedTimer) {
                                ForEach(timerOptions, id: \.self) { time in
                                    Text(formatTime(time)).tag(time)
                                }
                            }
                        }

                    }
                    .scrollContentBackground(.hidden)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.3, green: 0.7, blue: 0.4), lineWidth: 2)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.85))
                            )
                    )
                    .padding(.horizontal)
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
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.4, green: 0.8, blue: 0.5),
                                        Color(red: 0.1, green: 0.5, blue: 0.2)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(12)
                            .shadow(radius: 4)
                            .padding(.horizontal)
                    }

                    .padding(.bottom, 20)

                }
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
