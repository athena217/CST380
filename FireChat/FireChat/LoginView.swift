//
//  LoginView.swift
//  FireChat
//
//  Created by Athena Lopez on 3/10/26.
//

import Foundation
import SwiftUI

struct LoginView: View {

    @Environment(AuthManager.self) var authManager

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
            VStack {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .padding(40)
            HStack {
                Button("Sign Up") {
                    print("Sign up user: \(email), \(password)")

                    // TODO: Sign up user
                    authManager.signUp(email: email, password: password) // <-- Sign up user via authManager

                }
                .buttonStyle(.borderedProminent)

                Button("Login") {
                    print("Login user: \(email), \(password)")

                    // TODO: Login user
                    authManager.signIn(email: email, password: password) // <-- Sign in user via authManager

                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
