//
//  SignUpViewController.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/26/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit
 // MARK: - Day 3 Changes
class SignUpViewController: UIViewController {
    
    var image: UIImage?
    var logInState = false
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var welcomLabel: UILabel!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var createUserButton: HypeButton!
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var usernameTextField: HypeTextField!
    @IBOutlet weak var passcodeTextField: HypeTextField!
    @IBOutlet weak var confirmPasscodeTextField: HypeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     fetchUser()
//        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        UserController.shared.createUserWith(username, profilePhoto: image) { (success) in
            if success {
                self.presentHypeListVC()
            }
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        switch logInState {
        case false:
            toggleToLogIn()
            logInState = true
        case true:
            toggleToSignUp()
            logInState = false
        }
    }
    
    func setupViews() {
         self.view.backgroundColor = .black
        photoContainerView.addCornerRadius(photoContainerView.frame.height / 2)
        photoContainerView.clipsToBounds = true
        logInButton.rotate()
        signUpButton.rotate()
        signUpButton.setTitleColor(.mainTextColor, for: .normal)
        logInButton.setTitleColor(.subltleTextColor, for: .normal)
        helpButton.setTitleColor(.mainTextColor, for: .normal)
        faqButton.setTitleColor(.greenAccent, for: .normal)
    }
    
    func fetchUser() {
        UserController.shared.fetchUser { (success) in
            if success {
                self.presentHypeListVC()
            }
        }
    }
    
    func presentHypeListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HypeList", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
    func toggleToLogIn() {
        UIView.animate(withDuration: 0.2) {
            self.logInButton.setTitleColor(.mainTextColor, for: .normal)
            self.signUpButton.setTitleColor(.subltleTextColor, for: .normal)
            self.createUserButton.setTitle("Log Me In!", for: .normal)
            self.confirmPasscodeTextField.isHidden = true
            self.helpButton.setTitle("Forgot?", for: .normal)
            self.faqButton.setTitle("Hint?", for: .normal)
        }
    }
    
    func toggleToSignUp() {
        UIView.animate(withDuration: 0.2) {
            self.logInButton.setTitleColor(.subltleTextColor, for: .normal)
            self.signUpButton.setTitleColor(.mainTextColor, for: .normal)
            self.createUserButton.setTitle("Sign Me Up!", for: .normal)
            self.confirmPasscodeTextField.isHidden = false
            self.helpButton.setTitle("Help", for: .normal)
            self.faqButton.setTitle("FAQ", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoPicerVC" {
            let destinationVC = segue.destination as? PhotoPickerViewController
            destinationVC?.delegate = self
        }
    }
}

// MARK: - Day 4 Changes
extension SignUpViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}
