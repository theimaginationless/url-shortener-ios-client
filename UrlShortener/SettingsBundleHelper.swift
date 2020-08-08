//
//  SettingsBundleHelper.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 07.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//
import Foundation

struct SettingsKey {
    static let UrlApiEndpoint = "api_url_endpoint"
}

class SettingsHelper {
    static func registerSettingsBundle() {
        guard let bundle = Bundle.main.url(forResource: "Settings", withExtension: "bundle") else {
            print("Error load settings bundle!")
            return
        }
        
        guard let preferences = NSDictionary(contentsOf: bundle.appendingPathComponent("Root.plist")) else {
            print("Error load settings dictionary")
            return
        }
        
        var defaultRegister = [String: Any]()
        for (key, value) in preferences {
            defaultRegister[key as! String] = value
        }
        
        UserDefaults.standard.register(defaults: defaultRegister)
    }
}
//http://theimless.me:8084/shortenUrl
