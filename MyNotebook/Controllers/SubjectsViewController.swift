//
//  SubjectsViewController.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/26/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit

class SubjectsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var subjects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    @IBAction func addNewSubjectTapped(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(item: self.subjects.count - 1, section: 0)
        
        collectionView.performBatchUpdates({
            self.collectionView?.insertItems(at: [indexPath])
        }, completion: nil)
        
    }
}

extension SubjectsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        
        return cell
    }
    
    
    
}
