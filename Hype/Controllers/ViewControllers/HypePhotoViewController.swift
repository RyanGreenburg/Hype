//
//  PhotoHypeViewController.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/27/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class HypePhotoViewController: UIViewController {

    var image: UIImage?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UITextField!
    @IBOutlet weak var photoContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let text = bodyTextLabel.text, !text.isEmpty,
            let image = self.image
            else { return }
        
        HypeController.shared.saveHype(with: text, photo: image) { (success) in
            if success {
                self.dismissView()
            }
        }
    }
    
    func setupViews() {
        photoContainerView.layer.cornerRadius = photoContainerView.frame.height / 10
        photoContainerView.clipsToBounds = true
    }
    
    private func dismissView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoPicerVC" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
        }
    }
}

extension HypePhotoViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}
