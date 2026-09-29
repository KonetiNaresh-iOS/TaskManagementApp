//
//  Validators.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import Foundation

enum Validator {
    static let minPasswordLength = 6

    static func email(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "Email is required." }
        let pattern = #"^[A-Z0-9a-z._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        return trimmed.range(of: pattern, options: .regularExpression) == nil
            ? "Enter a valid email address."
            : nil
    }

    static func password(_ value: String) -> String? {
        value.count < minPasswordLength
            ? "Password must be at least \(minPasswordLength) characters."
            : nil
    }

    static func confirmPassword(_ confirm: String, matches password: String) -> String? {
        confirm == password ? nil : "Passwords don't match."
    }

    // MARK: Tasks (used in Module 3)

    static func title(_ value: String) -> String? {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Title is required."
            : nil
    }

    static func dueDate(_ date: Date, now: Date = .now, calendar: Calendar = .current) -> String? {
        date < calendar.startOfDay(for: now) ? "Due date can't be in the past." : nil
    }
}
