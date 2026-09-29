//
//  FontManager.swift
//  TaskManagementApp
//
//  Created by K Naresh on 28/09/26.
//

import SwiftUI
import CoreText
import Combine

struct RemoteFont {
    let postScriptName: String
    let url: URL

    /// Poppins from the official Google Fonts repository (OFL licence).
    static let poppins: [RemoteFont] = ["Regular", "Medium", "SemiBold", "Bold"].compactMap { weight in
        guard let url = URL(string: "https://raw.githubusercontent.com/google/fonts/main/ofl/poppins/Poppins-\(weight).ttf")
        else { return nil }
        return RemoteFont(postScriptName: "Poppins-\(weight)", url: url)
    }
}


@MainActor
class FontManager: ObservableObject {
    var objectWillChange: ObservableObjectPublisher

    static let shared = FontManager()

    @Published private(set) var revision = 0

    var fonts = RemoteFont.poppins
    var directory: URL
    var registered = Set<String>()

    private init() {
        self.objectWillChange = ObservableObjectPublisher()

        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        directory = base.appendingPathComponent("Fonts", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        for font in fonts {
            registerIfCached(font)
        }
    }

    func loadMissingFonts() async {
        for font in fonts where !registered.contains(font.postScriptName) {
            await download(font)
        }
    }

    func fileURL(for font: RemoteFont) -> URL {
        directory.appendingPathComponent("\(font.postScriptName).ttf")
    }

    func download(_ font: RemoteFont) async {
        do {
            let (data, response) = try await URLSession.shared.data(from: font.url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
            try data.write(to: fileURL(for: font), options: .atomic)
            registerIfCached(font)
        } catch {
            // Offline or blocked: keep the system font.
        }
    }

    @discardableResult
    func registerIfCached(_ font: RemoteFont) -> Bool {
        let file = fileURL(for: font)
        guard FileManager.default.fileExists(atPath: file.path) else { return false }

        var error: Unmanaged<CFError>?
        let ok = CTFontManagerRegisterFontsForURL(file as CFURL, .process, &error)
        var alreadyRegistered = false
        if let cfError = error?.takeRetainedValue() {
            alreadyRegistered = CFErrorGetCode(cfError) == CTFontManagerError.alreadyRegistered.rawValue
        }

        if ok || alreadyRegistered {
            registered.insert(font.postScriptName)
            revision += 1
            return true
        }
        try? FileManager.default.removeItem(at: file) 
        return false
    }
}
