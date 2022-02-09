//
//  BruteForce.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

class BruteForce {
    
    func bruteForce(passwordToUnlock: String, completion: @escaping()->()) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        print("Подбираю пароль")
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
        }
        completion()
        print("Пароль: \(password)")
    }
    
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var string: String = string
        
        if string.count <= 0 {
            string.append(characterAt(index: 0, array))
        }
        else {
            string.replace(at: string.count - 1, with: characterAt(index: (indexOf(character: string.last!, array) + 1) % array.count, array))
            
            if indexOf(character: string.last!, array) == 0 {
                string = String(generateBruteForce(String(string.dropLast()), fromArray: array)) + String(string.last!)
            }
        }
        return string
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }
    
    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index]): Character("")
    }
}

extension String {
    //    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    //    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    //    var printable:   String { return digits + letters + punctuation }
    var printable:   String { return letters }
    
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}
