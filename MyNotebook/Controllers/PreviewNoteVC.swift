//
//  PreviewNoteVC.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/26/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit

class PreviewNoteVC: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    var note : Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        
        
    }
    


}

extension PreviewNoteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return note.notePages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotePagesCollectionCell", for: indexPath) as! NotePagesCollectionCell
        
        cell.noteImage.image = note.notePages[indexPath.row]
        
        return cell
    }
    
    
}

class NotePagesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var noteImage: UIImageView!
    
    
}
