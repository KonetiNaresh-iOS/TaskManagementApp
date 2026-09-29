//
//  LoginView.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject  var auth: AuthViewModel
    @State  var showingReset = false
    @FocusState  var focus: Field?

    enum Field { case email, password }

    var body: some View {
        ZStack {
            AuthBackground()

            ScrollView {
                VStack(spacing: 20) {
                    header

                    VStack(spacing: 14) {
                        AppTextField(title: "Email", icon: RemoteAssets.mail, text: $auth.email,
                                     error: auth.emailError, keyboard: .emailAddress,
                                     contentType: .username)
                            .focused($focus, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focus = .password }

                        AppTextField(title: "Password", icon: RemoteAssets.lock, text: $auth.password,
                                     isSecure: true, contentType: .password)
                            .focused($focus, equals: .password)
                            .submitLabel(.go)
                            .onSubmit(signIn)
                    }

                    HStack {
                        Spacer()
                        Button("Forgot password?") {
                            auth.clearMessages()
                            showingReset = true
                        }
                        .font(AppFont.subheadline)
                        .foregroundStyle(.white)
                    }

                    if let message = auth.errorMessage {
                        ErrorBanner(message: message)
                    }

                    PrimaryButton(title: "Sign In",
                                  isLoading: auth.isLoading,
                                  isEnabled: auth.isSignInValid,
                                  action: signIn)

                    HStack(spacing: 4) {
                        Text("New here?").foregroundStyle(.white.opacity(0.7))
                        NavigationLink("Create an account") { SignUpView() }
                            .font(AppFont.headline)
                            .foregroundStyle(.white)
                    }
                    .font(AppFont.subheadline)
                }
                .padding(24)
                .animation(.easeInOut(duration: 0.2), value: auth.errorMessage)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarHidden(true)
        .onAppear { auth.clearMessages() }
        .sheet(isPresented: $showingReset) {
            ForgotPasswordView()
                .presentationDetents([.medium])
        }
    }

    var header: some View {
        VStack(spacing: 10) {
            RemoteIcon(url: RemoteAssets.logo, size: 84, tinted: false)
            Text("Welcome back")
                .font(AppFont.largeTitle)
                .foregroundStyle(.white)
            Text("Sign in to manage your tasks")
                .font(AppFont.body)
                .foregroundStyle(.white.opacity(0.75))
        }
        .padding(.top, 60)
        .padding(.bottom, 8)
    }

    func signIn() {
        focus = nil
        Task { await auth.signIn() }
    }
}
