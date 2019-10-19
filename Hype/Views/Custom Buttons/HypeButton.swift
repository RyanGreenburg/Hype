//
//  HypeButton.swift
//  Hype
//
//  Created by RYAN GREENBURG on 10/18/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class HypeButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        updateFontTo(font: FontNames.latoRegular)
        self.backgroundColor = .greenAccent
        self.setTitleColor(.mainTextColor, for: .normal)
        self.addCornerRadius()
    }
    
    func updateFontTo(font: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: font, size: size)!
    }
}
