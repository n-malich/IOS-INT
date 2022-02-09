//
//  NetworkService.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

struct NetworkService {
    
    static func performRequest(with url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, responce, error in
            guard let data = data, let responce = responce as? HTTPURLResponse else {
                guard let error = error else { return }
                print("Web service didn't respond: \(error.localizedDescription)")
                return
            }
            //If there is no wifi: Code=-1009 "The Internet connection appears to be offline."
            print ("Data: \(String(decoding: data, as: UTF8.self))")
            print("Response header fields: \(responce.allHeaderFields)")
            print("Response code: \(responce.statusCode)")
        }.resume()
    }
}

