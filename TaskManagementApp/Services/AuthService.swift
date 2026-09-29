//
//  AuthService.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import Foundation
import Combine
import FirebaseAuth

struct AuthUser: Equatable {
    let uid: String
    let email: String?
}

protocol AuthServiceProtocol {
    var currentUser: AuthUser? { get }
    var userPublisher: AnyPublisher<AuthUser?, Never> { get }
    func signUp(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws
    func sendPasswordReset(email: String) async throws
    func signOut() throws
}

class AuthService: AuthServiceProtocol {
    private let auth: Auth
    private let subject: CurrentValueSubject<AuthUser?, Never>
    private var handle: AuthStateDidChangeListenerHandle?

    init(auth: Auth = Auth.auth()) {
        self.auth = auth
        // currentUser is restored synchronously from the Keychain, which avoids a login-screen flash.
        self.subject = CurrentValueSubject(Self.map(auth.currentUser))
        self.handle = auth.addStateDidChangeListener { [weak self] _, user in
            self?.subject.send(Self.map(user))
        }
    }

    deinit {
        if let handle { auth.removeStateDidChangeListener(handle) }
    }

    var currentUser: AuthUser? { subject.value }

    var userPublisher: AnyPublisher<AuthUser?, Never> {
        subject.removeDuplicates().eraseToAnyPublisher()
    }

    func signUp(email: String, password: String) async throws {
        _ = try await auth.createUser(withEmail: clean(email), password: password)
    }

    func signIn(email: String, password: String) async throws {
        _ = try await auth.signIn(withEmail: clean(email), password: password)
    }

    func sendPasswordReset(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: clean(email))
    }

    func signOut() throws {
        try auth.signOut()
    }

    private func clean(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func map(_ user: User?) -> AuthUser? {
        user.map { AuthUser(uid: $0.uid, email: $0.email) }
    }
}
