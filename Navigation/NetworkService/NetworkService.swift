//
//  NetworkService.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

struct NetworkService {
    
    private static var url = URL(string: "https://jsonplaceholder.typicode.com/todos/106")
    
    static func performRequest(returnedTitle: @escaping (String) -> Void) {
        guard let url = url else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, responce, error in
            if let data = data {
                do {
                    let serializedDictionary = try JSONSerialization.jsonObject(with: data, options: [])
                    print(serializedDictionary)
                    
                    if let dict = serializedDictionary as? [String: Any], let title = dict["title"] as? String {
                        DispatchQueue.main.async {
                            returnedTitle(title)
                        }
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
