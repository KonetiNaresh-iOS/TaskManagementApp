//
//  ErrorBanner.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

struct ErrorBanner: View {
    enum Kind { case error, success }

    var message: String
    var kind: Kind = .error

    var tint: Color { kind == .error ? .red : .green }
    var icon: URL? { kind == .error ? RemoteAssets.error : RemoteAssets.success }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            RemoteIcon(url: icon, size: 18)
                .foregroundStyle(tint)
            Text(message)
                .font(AppFont.subheadline)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}
