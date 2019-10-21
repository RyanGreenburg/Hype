//
//  HypeCollectionViewCell.swift
//  Hype
//
//  Created by RYAN GREENBURG on 10/21/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class HypeCollectionViewCell: UICollectionViewCell {
    
    var hype: Hype? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hypeBodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var hypeImageView: UIImageView!
    
    
    func updateViews() {
        guard let hype = hype else { return }
        self.hypeBodyLabel.text = hype.body
        self.timestampLabel.text = hype.timestamp.formatDate()
        self.hypeImageView.image = hype.hypePhoto
    }
}
