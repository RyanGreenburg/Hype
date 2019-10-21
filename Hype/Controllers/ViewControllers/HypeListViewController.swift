//
//  HypeListViewController.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/25/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class HypeListViewController: UIViewController {

   // MARK: - Class Properties
    var refresh: UIRefreshControl = UIRefreshControl()
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadData()
    }
    
    // MARK: - Actions
    @IBAction func addHypeButtonTapped(_ sender: Any) {
        presentHypeAlert(for: nil)
    }
    
    // MARK: - Class Methods
    func setUpViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        refresh.attributedTitle = NSAttributedString(string: "Pull to see new Hypes")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
//        tableView.addSubview(refresh)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    @objc func loadData() {
        HypeController.shared.fetchAllHypes { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
    // MARK: - Day 2 changes
    func presentHypeAlert(for hype: Hype?) {
        let alertController = UIAlertController(title: "Get Hype!", message: "What is hype may never die", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.delegate = self
            textField.placeholder = "What is hype today?"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            if let hype = hype {
                textField.text = hype.body
            }
        }
        
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            if let hype = hype {
                hype.body = text
                HypeController.shared.update(hype) { (success) in
                    if success {
                        self.updateViews()
                    }
                }
            } else {
                HypeController.shared.saveHype(with: text, photo: nil) { (success) in
                    if success {
                        self.updateViews()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addHypeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}

// MARK: - CollectionView DataSource/Delegate Conformance
extension HypeListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HypeController.shared.hypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hypeCell", for: indexPath) as? HypeCollectionViewCell
        
        let hype = HypeController.shared.hypes[indexPath.row]
        
        cell?.hype = hype
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.view.frame.height / 4)
    }
}

// MARK: - TextFieldDelegate Confromance
extension HypeListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

