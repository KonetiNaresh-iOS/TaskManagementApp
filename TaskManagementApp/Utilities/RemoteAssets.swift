//
//  RemoteAssets.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import Foundation

enum RemoteAssets {
    private static func glyph(_ name: String) -> URL? {
        URL(string: "https://img.icons8.com/ios-glyphs/60/\(name).png")
    }

    // Brand / illustration (full colour, not tinted)
    static let logo = URL(string: "https://img.icons8.com/fluency/240/todo-list.png")

    // Full-screen background photo for the auth screens (Unsplash, free to use).
    static let authBackground = URL(string: "https://images.unsplash.com/photo-1497215842964-222b430dc094?w=1200&q=80")

    // Field icons
    static var mail = glyph("mail")
    static var lock = glyph("lock")
    static var key  = glyph("key")

    // Status icons
    static var error   = glyph("high-priority")
    static var success = glyph("checked--v1")
}
