//
//  AppTextField.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

struct AppTextField: View {
    var title: String
    var icon: URL?
    @Binding var text: String
    var error: String? = nil
    var isSecure = false
    var keyboard: UIKeyboardType = .default
    var contentType: UITextContentType? = nil

    @State var revealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                RemoteIcon(url: icon, size: 20)
                    .foregroundStyle(.white.opacity(0.85))

                Group {
                    if isSecure && !revealed {
                        SecureField("", text: $text, prompt: Text(title).foregroundColor(.white.opacity(0.5)))
                    } else {
                        TextField("", text: $text, prompt: Text(title).foregroundColor(.white.opacity(0.5)))
                    }
                }
                .font(AppFont.body)
                .foregroundStyle(.white)
                .tint(.white)
                .keyboardType(keyboard)
                .textContentType(contentType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                if isSecure {
                    Button(revealed ? "Hide" : "Show") { revealed.toggle() }
                        .font(AppFont.caption)
                        .foregroundStyle(.white.opacity(0.75))
                }
            }
            .padding(14)
            .background(.ultraThinMaterial.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(error == nil ? Color.white.opacity(0.25) : Color.red.opacity(0.8), lineWidth: 1)
            )

            if let error {
                Text(error)
                    .font(AppFont.caption)
                    .foregroundStyle(.red)
                    .padding(.leading, 4)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: error)
    }
}
