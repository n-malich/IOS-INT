//
//  CustomTextField.swift
//  Navigation
//
//  Created by Natali Malich
//

import UIKit

class CustomTextField: UITextField {
    
    init(font: UIFont?, textColor: UIColor?, backgroundColor: UIColor?, placeholder: String?) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.placeholder = placeholder
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
        self.autocapitalizationType = .none
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}
