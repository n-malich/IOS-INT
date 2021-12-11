//
//  CheckEnteredWord.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation

class CheckEnteredWord {
    
    private let correctWord = "Пароль"
    
    func checkWord(enteredWord: String?, onChecked: (Bool) -> Void) -> Void {
        onChecked(enteredWord == correctWord)
    }
}
