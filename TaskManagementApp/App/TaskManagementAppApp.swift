//
//  TaskManagementAppApp.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI
import FirebaseCore

@main
struct TaskManagementAppApp: App {
    @StateObject private var auth: AuthViewModel

    init() {
        // Bigger cache so remote icons/images are reused instead of re-downloaded.
        URLCache.shared = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                   diskCapacity: 200 * 1024 * 1024)

        // Must run BEFORE any Firebase service is touched. The App initializer
        // runs before UIApplicationDelegate.didFinishLaunching, so we configure here.
        FirebaseApp.configure()
        _auth = StateObject(wrappedValue: AuthViewModel(service: AuthService()))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .task { await FontManager.shared.loadMissingFonts() }
        }
    }
}
