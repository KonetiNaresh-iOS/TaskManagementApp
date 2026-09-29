//
//  AppError.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import Foundation
import FirebaseAuth

enum AppError {
    static func message(for error: Error) -> String {
        let nsError = error as NSError

        if nsError.domain == AuthErrorDomain,
           let code = AuthErrorCode(rawValue: nsError.code) {
            switch code {
            case .wrongPassword, .invalidCredential:
                return "Incorrect email or password."
            case .userNotFound:
                return "No account found for this email."
            case .emailAlreadyInUse:
                return "An account with this email already exists."
            case .weakPassword:
                return "Password must be at least 6 characters."
            case .invalidEmail:
                return "Please enter a valid email address."
            case .userDisabled:
                return "This account has been disabled."
            case .tooManyRequests:
                return "Too many attempts. Please wait a moment and try again."
            case .networkError:
                return "No internet connection. Please try again."
            default:
                break
            }
        }

        if nsError.domain == NSURLErrorDomain {
            return "No internet connection. Please try again."
        }
        return "Something went wrong. Please try again."
    }
}
