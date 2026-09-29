//
//  AuthBackground.swift
//  TaskManagementApp
//
//  Created by K Naresh on 30/09/26.
//

import SwiftUI

struct AuthBackground: View {
    var body: some View {
        GeometryReader { geo in
            AsyncImage(url: RemoteAssets.authBackground,
                       transaction: Transaction(animation: .easeIn(duration: 0.4))) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                default:
                    // Falls back to a plain dark gradient while loading or if offline.
                    LinearGradient(colors: [Color.black, Color(.systemGray6).opacity(0.4)],
                                   startPoint: .top, endPoint: .bottom)
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            }
        }
        .overlay(
            LinearGradient(
                colors: [Color.black.opacity(0.55), Color.black.opacity(0.75)],
                startPoint: .top, endPoint: .bottom
            )
        )
        .ignoresSafeArea()
    }
}
