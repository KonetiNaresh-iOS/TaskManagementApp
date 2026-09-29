//
//  AuthViewModelTests.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import XCTest
import Combine
@testable import TaskManagementApp

class MockAuthService: AuthServiceProtocol {
    var currentUser: AuthUser?
    let subject = CurrentValueSubject<AuthUser?, Never>(nil)
    var userPublisher: AnyPublisher<AuthUser?, Never> { subject.eraseToAnyPublisher() }

    var errorToThrow: Error?
    var signInCalls = 0
    var signUpCalls = 0
    var resetCalls = 0

    func signUp(email: String, password: String) async throws {
        signUpCalls += 1
        if let errorToThrow { throw errorToThrow }
    }
    func signIn(email: String, password: String) async throws {
        signInCalls += 1
        if let errorToThrow { throw errorToThrow }
    }
    func sendPasswordReset(email: String) async throws {
        resetCalls += 1
        if let errorToThrow { throw errorToThrow }
    }
    func signOut() throws {}
}

@MainActor
final class AuthViewModelTests: XCTestCase {

    func test_signIn_disabledUntilFormValid() {
        let vm = AuthViewModel(service: MockAuthService())
        XCTAssertFalse(vm.isSignInValid)
        vm.email = "user@example.com"
        vm.password = "secret1"
        XCTAssertTrue(vm.isSignInValid)
    }

    func test_signUp_requiresMatchingPasswords() {
        let vm = AuthViewModel(service: MockAuthService())
        vm.email = "user@example.com"
        vm.password = "secret1"
        vm.confirmPassword = "different"
        XCTAssertFalse(vm.isSignUpValid)
        XCTAssertNotNil(vm.confirmPasswordError)
        vm.confirmPassword = "secret1"
        XCTAssertTrue(vm.isSignUpValid)
    }

    func test_signIn_failureSetsFriendlyMessageAndStopsLoading() async {
        let service = MockAuthService()
        service.errorToThrow = URLError(.notConnectedToInternet)
        let vm = AuthViewModel(service: service)
        vm.email = "user@example.com"
        vm.password = "secret1"

        await vm.signIn()

        XCTAssertEqual(service.signInCalls, 1)
        XCTAssertEqual(vm.errorMessage, "No internet connection. Please try again.")
        XCTAssertFalse(vm.isLoading)
    }

    func test_signIn_invalidForm_doesNotCallService() async {
        let service = MockAuthService()
        let vm = AuthViewModel(service: service)
        vm.email = "bad"
        await vm.signIn()
        XCTAssertEqual(service.signInCalls, 0)
    }

    func test_passwordReset_showsNonRevealingInfoMessage() async {
        let service = MockAuthService()
        let vm = AuthViewModel(service: service)
        vm.email = "user@example.com"

        await vm.sendPasswordReset()

        XCTAssertEqual(service.resetCalls, 1)
        XCTAssertNotNil(vm.infoMessage)
        XCTAssertNil(vm.errorMessage)
    }
}
