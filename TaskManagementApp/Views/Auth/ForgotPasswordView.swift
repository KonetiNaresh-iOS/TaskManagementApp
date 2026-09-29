//
//  ForgotPasswordView.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AuthBackground()

                VStack(spacing: 20) {
                    Text("Reset password")
                        .font(AppFont.title)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Enter the email linked to your account and we'll send you a link to reset your password.")
                        .font(AppFont.subheadline)
                        .foregroundStyle(.white.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    AppTextField(title: "Email", icon: RemoteAssets.mail, text: $auth.email,
                                 error: auth.emailError, keyboard: .emailAddress,
                                 contentType: .emailAddress)

                    if let message = auth.errorMessage {
                        ErrorBanner(message: message)
                    }
                    if let info = auth.infoMessage {
                        ErrorBanner(message: info, kind: .success)
                    }

                    PrimaryButton(title: "Send Reset Link",
                                  isLoading: auth.isLoading,
                                  isEnabled: auth.isResetValid) {
                        Task { await auth.sendPasswordReset() }
                    }

                    Spacer()
                }
                .padding(24)
                .padding(.top, 24)
                .animation(.easeInOut(duration: 0.2), value: auth.errorMessage)
                .animation(.easeInOut(duration: 0.2), value: auth.infoMessage)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .font(AppFont.body)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}
