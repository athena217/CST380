//
//  TriviaGameView.swift
//  Project5-TriviaGame
//
//  Created by Athena Lopez on 3/12/26.
//

import Foundation
import SwiftUI


struct TriviaGameView: View {
    @StateObject private var viewModel = TriviaViewModel()

    let amount: Int
    let category: Int
    let difficulty: String
    let type: String
    let timer: Int

    @State private var showScoreAlert = false
    @State private var submitted = false

    var body: some View {
        ZStack {
            Color(red: 0.88, green: 0.95, blue: 0.88)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text("Questions: \(viewModel.questions.count)")
                        .foregroundColor(Color(red: 0.05, green: 0.4, blue: 0.15))
                        .fontWeight(.bold)
                    Spacer()
                    Text("Time: \(formatTime(viewModel.timeRemaining))")
                        .monospacedDigit()
                        .foregroundColor(Color(red: 0.05, green: 0.4, blue: 0.15))
                        .fontWeight(.bold)
                }
                .padding(.horizontal)

                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading Questions…")
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.05, green: 0.4, blue: 0.15)))
                        .foregroundColor(Color(red: 0.05, green: 0.4, blue: 0.15))
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.questions) { question in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(question.question)
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.05, green: 0.35, blue: 0.15))

                                    let answers = question.incorrect_answers + [question.correct_answer]
                                    ForEach(answers, id: \.self) { answer in
                                        HStack {
                                            Text(answer)
                                                .foregroundColor(.black)
                                            Spacer()
                                            if viewModel.selectedAnswers[question.id] == answer {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(submitted ? .white : .gray)
                                                    .font(.headline)
                                            }
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(answerBackground(for: question, answer: answer))
                                                .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
                                        )
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            guard !submitted else { return } // no changing after submit
                                            viewModel.selectAnswer(for: question, answer: answer)
                                        }
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 0.3, green: 0.7, blue: 0.4), lineWidth: 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.white.opacity(0.85))
                                        )
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    Button(action: {
                        submitted = true
                        viewModel.calculateScore()
                        showScoreAlert = true
                    }) {
                        Text("Submit")
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
                    .padding(.bottom)
                }
            }
        }
        .navigationTitle("Trivia Game")
        .task {
            await viewModel.loadTrivia(
                amount: amount,
                category: category,
                difficulty: difficulty,
                type: type,
                timerDuration: timer
            )
        }
        .onChange(of: viewModel.timerFinished) { _, finished in
            if finished {
                submitted = true
                viewModel.calculateScore()
                showScoreAlert = true
            }
        }
        .alert("Your Score", isPresented: $showScoreAlert) {
            Button("OK") {}
        } message: {
            Text("You got \(viewModel.score) out of \(viewModel.questions.count) correct.")
        }
    }
    
    private func answerBackground(for question: TriviaQuestion, answer: String) -> Color {
        if !submitted {
            return viewModel.selectedAnswers[question.id] == answer ? Color.gray.opacity(0.2) : Color.white.opacity(0.9)
        } else {
            if answer == question.correct_answer {
                return Color.green.opacity(0.3)
            } else if viewModel.selectedAnswers[question.id] == answer {
                return Color.red.opacity(0.3)
            } else {
                return Color.white.opacity(0.9)
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        if seconds >= 3600 { return "1:00:00" }
        if seconds >= 60 {
            let m = seconds / 60
            let s = seconds % 60
            return String(format: "%d:%02d", m, s)
        }
        return "\(seconds)s"
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
