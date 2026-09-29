//
//  AppFont.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI

enum AppFont {
    private static func poppins(_ weight: String, _ size: CGFloat, _ style: Font.TextStyle) -> Font {
        .custom("Poppins-\(weight)", size: size, relativeTo: style)
    }

    static let largeTitle  = poppins("Bold", 32, .largeTitle)
    static let title       = poppins("SemiBold", 22, .title2)
    static let headline    = poppins("SemiBold", 17, .headline)
    static let body        = poppins("Regular", 16, .body)
    static let subheadline = poppins("Regular", 14, .subheadline)
    static let caption     = poppins("Regular", 12, .caption)
    static let button      = poppins("Medium", 16, .body)
}
