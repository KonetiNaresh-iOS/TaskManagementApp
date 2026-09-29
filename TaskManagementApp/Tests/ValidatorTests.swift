//
//  ValidatorTests.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import XCTest
@testable import TaskManagementApp

class ValidatorTests: XCTestCase {

    func test_email_validAndInvalid() {
        XCTAssertNil(Validator.email("user@example.com"))
        XCTAssertNil(Validator.email("  user.name+tag@mail.co.in  "))
        XCTAssertNotNil(Validator.email(""))
        XCTAssertNotNil(Validator.email("not-an-email"))
        XCTAssertNotNil(Validator.email("a@b"))
    }

    func test_password_minimumLength() {
        XCTAssertNotNil(Validator.password("12345"))
        XCTAssertNil(Validator.password("123456"))
    }

    func test_confirmPassword() {
        XCTAssertNil(Validator.confirmPassword("secret1", matches: "secret1"))
        XCTAssertNotNil(Validator.confirmPassword("secret2", matches: "secret1"))
    }

    func test_title_requiresNonBlank() {
        XCTAssertNotNil(Validator.title(""))
        XCTAssertNotNil(Validator.title("   \n"))
        XCTAssertNil(Validator.title("Buy milk"))
    }

    func test_dueDate_rejectsPastAllowsTodayAndFuture() {
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
        XCTAssertNotNil(Validator.dueDate(yesterday, now: now))
        XCTAssertNil(Validator.dueDate(now, now: now))
        XCTAssertNil(Validator.dueDate(tomorrow, now: now))
    }
}
