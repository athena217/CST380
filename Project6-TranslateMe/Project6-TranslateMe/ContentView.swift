//
//  ContentView.swift
//  Project6-TranslateMe
//
//  Created by Athena Lopez on 3/17/26.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TranslationViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("TranslateMe")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                TextField("Enter text", text: $vm.inputText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green.darker())
                    .cornerRadius(10)
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    VStack {
                        Text("From")
                            .font(.headline)
                            .foregroundColor(.white)
                        Picker("Source", selection: $vm.sourceLanguage) {
                            ForEach(vm.languages.keys.sorted(), id: \.self) { code in
                                Text(vm.languages[code]!).tag(code)
                                    .foregroundColor(.black)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(6)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(8)
                    }
                    VStack {
                        Text("To")
                            .font(.headline)
                            .foregroundColor(.white)
                        Picker("Target", selection: $vm.targetLanguage) {
                            ForEach(vm.languages.keys.sorted(), id: \.self) { code in
                                Text(vm.languages[code]!).tag(code)
                                    .foregroundColor(.black)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(6)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task { await vm.translate() }
                }) {
                    Text("Translate")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.green.darker())
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
                .scaleEffect(vm.outputText.isEmpty ? 1 : 1.05)
                .animation(.spring(), value: vm.outputText)
                
                VStack(alignment: .leading) {
                    Text(vm.outputText.isEmpty ? "Translation will appear here" : vm.outputText)
                        .foregroundColor(vm.outputText.isEmpty ? .gray.opacity(0.8) : .white)
                        .padding()
                        .transition(.opacity)
                        .animation(.easeIn, value: vm.outputText)
                }
                .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
                .background(Color.green.opacity(0.3))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink("View Saved Translations") {
                    HistoryView(vm: vm)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 40)
                
            }
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    colors: [Color.green.darker(), Color.green.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    ContentView()
}

extension Color {
    func darken(amount: Double = 0.3) -> Color {
        return self.opacity(1.0 - amount)
    }
    func darker(amount: Double = 0.7) -> Color {
        return self.opacity(1.0 - amount)
    }
}
