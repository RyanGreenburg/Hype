//
//  HypeTextField.swift
//  Hype
//
//  Created by RYAN GREENBURG on 10/18/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class HypeTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.addCornerRadius(10)
        self.addAccentBorder()
        setupPlaceholderText()
        updateFontTo(font: FontNames.latoRegular)
        self.textColor = .mainTextColor
        self.tintColor = .mainTextColor
        self.backgroundColor = .blackOverlay
        self.layer.masksToBounds = true
    }
    
    func setupPlaceholderText() {
        let currentPlaceholder = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholder ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.subltleTextColor,
            NSAttributedString.Key.font: UIFont(name: FontNames.latoLight, size: 16)!
        ])
    }
    
    func updateFontTo(font: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: font, size: size)!
    }
}
