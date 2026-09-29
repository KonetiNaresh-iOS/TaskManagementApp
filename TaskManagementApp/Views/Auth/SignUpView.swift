//
//  SignUpView.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var auth: AuthViewModel
    @FocusState var focus: Field?

    enum Field { case email, password, confirm }

    var body: some View {
        ZStack {
            AuthBackground()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Create account")
                            .font(AppFont.largeTitle)
                            .foregroundStyle(.white)
                        Text("Start organising your day")
                            .font(AppFont.body)
                            .foregroundStyle(.white.opacity(0.75))
                    }
                    .padding(.top, 40)

                    VStack(spacing: 14) {
                        AppTextField(title: "Email", icon: RemoteAssets.mail, text: $auth.email,
                                     error: auth.emailError, keyboard: .emailAddress,
                                     contentType: .username)
                            .focused($focus, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focus = .password }

                        AppTextField(title: "Password", icon: RemoteAssets.lock, text: $auth.password,
                                     error: auth.passwordError, isSecure: true,
                                     contentType: .newPassword)
                            .focused($focus, equals: .password)
                            .submitLabel(.next)
                            .onSubmit { focus = .confirm }

                        AppTextField(title: "Confirm password", icon: RemoteAssets.key,
                                     text: $auth.confirmPassword, error: auth.confirmPasswordError,
                                     isSecure: true, contentType: .newPassword)
                            .focused($focus, equals: .confirm)
                            .submitLabel(.go)
                            .onSubmit(signUp)
                    }

                    if let message = auth.errorMessage {
                        ErrorBanner(message: message)
                    }

                    PrimaryButton(title: "Sign Up",
                                  isLoading: auth.isLoading,
                                  isEnabled: auth.isSignUpValid,
                                  action: signUp)
                }
                .padding(24)
                .animation(.easeInOut(duration: 0.2), value: auth.errorMessage)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { auth.clearMessages() }
    }

    func signUp() {
        focus = nil
        Task { await auth.signUp() }
    }
}
