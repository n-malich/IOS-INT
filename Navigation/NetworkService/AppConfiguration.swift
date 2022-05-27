//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case url1 = "https://swapi.dev/api/people/8"
    case url2 = "https://swapi.dev/api/starships/3"
    case url3 = "https://swapi.dev/api/planets/5"
}

extension AppConfiguration {
    static func getRandomURL() -> String {
        guard let result = AppConfiguration.allCases.randomElement()?.rawValue else { return "Can't get URL" }
        return result
    }
}
