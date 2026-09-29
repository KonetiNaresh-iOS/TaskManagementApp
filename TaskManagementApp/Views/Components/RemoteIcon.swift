//
//  RemoteIcon.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

struct RemoteIcon: View {
    var url: URL?
    var size: CGFloat = 20
    var tinted = true

    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeIn(duration: 0.2))) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .renderingMode(tinted ? .template : .original)
                    .scaledToFit()
            default:
                RoundedRectangle(cornerRadius: size * 0.25)
                    .fill(Color.secondary.opacity(0.15))
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
