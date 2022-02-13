//
//  NetworkService.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

struct NetworkService {
    
    private static var url = URL(string: "https://swapi.dev/api/planets/1")
    
    static func performRequest(returnedTitle: @escaping (String) -> Void) {
        guard let url = url else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, responce, error in
            if let data = data {
                do {
                    let planet = try JSONDecoder().decode(Planet.self, from: data)
                    DispatchQueue.main.async {
                        returnedTitle(planet.orbitalPeriod)
                    }
                }
                catch let error {
                    print("Web service didn't respond: \(error.localizedDescription)")
                }
                return
            }
        }.resume()
    }
}
