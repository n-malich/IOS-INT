//
//  NetworkService.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

struct NetworkService {
    
    private static var url = URL(string: "https://swapi.dev/api/planets/1")
    
    static func getResidents(completion: @escaping ([String]) -> Void) {
        guard let url = url else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, responce, error in
            if let data = data {
                do {
                    let planet = try JSONDecoder().decode(Planet.self, from: data)
                    let residentsUrls = planet.residents
                    var residentsNames = [String]()
                    var count = 0
                    let lock = NSLock()
                    for url in residentsUrls {
                        getNameResident(url: url) { name in
                            lock.lock()
                            residentsNames.append(name)
                            count += 1
                            lock.unlock()
                            if count == residentsUrls.count {
                                DispatchQueue.main.async {
                                    completion(residentsNames)
                                }
                            }
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
    
    private static func getNameResident(url: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, responce, error in
            if let data = data {
                do {
                    let resident = try JSONDecoder().decode(Resident.self, from: data)
                    completion(resident.name)
                }
                catch let error {
                    print(error.localizedDescription)
                }
                return
            }
        }.resume()
    }
}
