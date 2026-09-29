//
//  RootView.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel
    @ObservedObject var fonts = FontManager.shared

    var body: some View {
        Group {
            if auth.user != nil {
                // Replaced by MainTabView in Module 3.
                HomePlaceholderView()
            } else {
                NavigationStack { LoginView() }
            }
        }
        .font(AppFont.body)
        .id(fonts.revision)
        .animation(.easeInOut(duration: 0.25), value: auth.user)
    }
}

/// Temporary landing screen so you can verify auth end to end.
struct HomePlaceholderView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            RemoteIcon(url: RemoteAssets.success, size: 56)
                .foregroundStyle(.green)
            Text("Signed in").font(AppFont.title)
            Text(auth.user?.email ?? "")
                .font(AppFont.subheadline)
                .foregroundStyle(.secondary)
            Button("Sign Out", role: .destructive) { auth.signOut() }
                .buttonStyle(.bordered)
        }
        .padding()
    }
}
