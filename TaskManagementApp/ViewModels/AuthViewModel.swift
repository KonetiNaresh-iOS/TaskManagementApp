//
//  AuthViewModel.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
  
    @Published var user: AuthUser?

    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var infoMessage: String?

    var service: AuthServiceProtocol
    var cancellables = Set<AnyCancellable>()

    init(service: AuthServiceProtocol) {
        self.service = service
        self.user = service.currentUser

        service.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
                self.user = user
                if user != nil { self.resetForm() }
            }
            .store(in: &cancellables)
    }

    // MARK: Inline validation (only shown once the user has typed something)

    var emailError: String? { email.isEmpty ? nil : Validator.email(email) }
    var passwordError: String? { password.isEmpty ? nil : Validator.password(password) }
    var confirmPasswordError: String? {
        confirmPassword.isEmpty ? nil : Validator.confirmPassword(confirmPassword, matches: password)
    }

    var isSignInValid: Bool {
        Validator.email(email) == nil && !password.isEmpty
    }

    var isSignUpValid: Bool {
        Validator.email(email) == nil
            && Validator.password(password) == nil
            && Validator.confirmPassword(confirmPassword, matches: password) == nil
    }

    var isResetValid: Bool { Validator.email(email) == nil }

    // MARK: Actions

    func signIn() async {
        guard isSignInValid else { return }
        await perform { try await self.service.signIn(email: self.email, password: self.password) }
    }

    func signUp() async {
        guard isSignUpValid else { return }
        await perform { try await self.service.signUp(email: self.email, password: self.password) }
    }

    func sendPasswordReset() async {
        guard isResetValid else { return }
        let target = email.trimmingCharacters(in: .whitespacesAndNewlines)
        await perform {
            try await self.service.sendPasswordReset(email: target)
            // Deliberately vague: don't reveal whether an account exists.
            self.infoMessage = "If an account exists for \(target), a reset link is on its way."
        }
    }

    func signOut() {
        do {
            try service.signOut()
            resetForm()
        } catch {
            errorMessage = AppError.message(for: error)
        }
    }

    func clearMessages() {
        errorMessage = nil
        infoMessage = nil
    }

    func resetForm() {
        email = ""
        password = ""
        confirmPassword = ""
        clearMessages()
    }

    // MARK: Private

func perform(_ work: () async throws -> Void) async {
        guard !isLoading else { return }
        clearMessages()
        isLoading = true
        defer { isLoading = false }
        do {
            try await work()
        } catch {
            errorMessage = AppError.message(for: error)
        }
    }
}
