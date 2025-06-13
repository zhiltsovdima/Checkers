//
//  AppSettings.swift
//  Checkers
//
//  Created by Dima Zhiltsov on 13.06.2025.
//

import Foundation

struct AppInfo {
    static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Russian Checkers"
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
}

enum AppBundle {
    static let test = ""
    static let production = ""

    private static let appBundle = Bundle.main.bundleIdentifier ?? production
    static var isReleaseBundle: Bool { appBundle == production }
    
    enum SharedKey { }
}
