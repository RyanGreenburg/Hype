//
//  HypeTableViewCell.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/27/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class HypeTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            updateUser()
        }
    }
    
    var hype: Hype? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hypeLabel: UILabel!
    @IBOutlet weak var hypeImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setupViews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.contentMode = .scaleAspectFill
        hypeImageView.layer.cornerRadius = hypeImageView.frame.height / 10
        hypeImageView.contentMode = .scaleAspectFill
    }
    
    func updateViews() {
        hypeImageView.image = nil
        guard let hype = hype else { return }
        hypeLabel.text = hype.body
        dateLabel.text = hype.timestamp.formatDate()
        
        if let hypeImage = hype.hypePhoto {
            hypeImageView.image = hypeImage
            hypeImageView.isHidden = false
        } else {
            hypeImageView.isHidden = true
        }
    }
    
    func updateUser() {
        guard let user = user else { return }
        DispatchQueue.main.async {
            self.usernameLabel.text = user.username
            self.profileImageView.image = user.profilePhoto
        }
    }
}
