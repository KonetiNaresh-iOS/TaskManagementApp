//
//  PrimaryButton.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var isLoading = false
    var isEnabled = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title).opacity(isLoading ? 0 : 1)
                if isLoading { ProgressView().tint(.white) }
            }
            .font(AppFont.button)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(isEnabled ? Color.accentColor : Color.gray.opacity(0.4),
                        in: RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled || isLoading)
        .animation(.easeInOut(duration: 0.15), value: isEnabled)
    }
}
