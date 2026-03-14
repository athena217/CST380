//
//  TriviaViewModel.swift
//  Project5-TriviaGame
//
//  Created by Athena Lopez on 3/13/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class TriviaViewModel: ObservableObject {

    @Published var questions: [TriviaQuestion] = []
    @Published var selectedAnswers: [UUID: String] = [:]
    @Published var isLoading = false
    @Published var score = 0
    @Published var timeRemaining: Int = 0
    @Published var timerFinished = false

    private var timer: Timer?
    private let api = TriviaAPI()

    func loadTrivia(amount: Int,
                    category: Int,
                    difficulty: String,
                    type: String,
                    timerDuration: Int) async {

        isLoading = true
        timeRemaining = timerDuration

        do {
            questions = try await api.fetchTrivia(
                amount: amount,
                category: category,
                difficulty: difficulty,
                type: type
            )
        } catch {
            print("Error fetching trivia:", error)
        }

        isLoading = false
        startTimer()
    }

    func selectAnswer(for question: TriviaQuestion, answer: String) {
        selectedAnswers[question.id] = answer
    }

    func calculateScore() {
        score = questions.filter { q in
            selectedAnswers[q.id] == q.correct_answer
        }.count
        stopTimer()
    }

    private func startTimer() {
        stopTimer()
        timerFinished = false

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }

            Task { @MainActor in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerFinished = true
                    self.stopTimer()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
