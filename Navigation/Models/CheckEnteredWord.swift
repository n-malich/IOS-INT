//
//  CheckEnteredWord.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

class CheckEnteredWord {
    
    private let correctWord = "Пароль"
    
    func checkWord(enteredWord: String) -> Bool {
        guard enteredWord.isEmpty || enteredWord != correctWord else { return true }
            return false
    }
}
