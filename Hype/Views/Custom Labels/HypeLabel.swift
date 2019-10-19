//
//  HypeLabel.swift
//  Hype
//
//  Created by RYAN GREENBURG on 10/18/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class HypeLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(fontName: FontNames.latoRegular)
        self.textColor = .mainTextColor
    }
    
    func updateFontTo(fontName: String) {
        let size = self.font.pointSize
        self.font = UIFont(name: fontName, size: size)!
    }
}

class HypeLabelLight: HypeLabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(fontName: FontNames.latoLight)
        self.textColor = .subltleTextColor
    }
}

class HypeLabelBold: HypeLabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFontTo(fontName: FontNames.latoBold)
    }
}
