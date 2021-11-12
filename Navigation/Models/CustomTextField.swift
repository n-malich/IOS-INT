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
        self.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.autocapitalizationType = .none
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}
