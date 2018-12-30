//
//  SubjectsViewController.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/26/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreData

class SubjectsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notebookLayoutView: UIView!
    @IBOutlet weak var notebookLayoutCollectionView: UICollectionView!
    @IBOutlet weak var transparentView: UIView!
    
    var notebookLayouts = ["notebook_camo", "notebook_camo_gray", "notebook_light_blue", "notebook_blue"]
    var subjects = [Notebook]()
    var selectedStyle: UIImage!
    var selectedSubject: Notebook!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.notebookLayoutCollectionView.delegate = self
        self.notebookLayoutCollectionView.dataSource = self
        self.notebookLayoutView.isHidden = true
        self.transparentView.isHidden = true
        
//        DataService.shared.deleteNotebookRecords()
        
        
        DataService.shared.fetchNotebooksData { (notebooksData) in
            self.subjects = notebooksData
            self.collectionView.reloadData()
        }
    }

    @IBAction func addNewSubjectTapped(_ sender: UIBarButtonItem) {
        self.notebookLayoutView.isHidden = false
        self.transparentView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNotes" {
            let destination = segue.destination as! NotesViewController
            destination.notebook = self.selectedSubject
        }
    }
}

extension SubjectsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return subjects.count
        }
        else {
            return notebookLayouts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectsCollectionViewCell", for: indexPath) as! SubjectsCollectionViewCell
            cell.subjectTitleLabel.text = subjects[indexPath.row].subject
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotebookLayoutCollectionViewCell", for: indexPath) as! NotebookLayoutCollectionViewCell
            let imageName = self.notebookLayouts[indexPath.row]
            cell.notebookImage.image = UIImage(named: imageName)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            self.selectedSubject = self.subjects[indexPath.row]
            self.performSegue(withIdentifier: "goToNotes", sender: self)
        }
        else {
            let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            
            let subject = alertView.addTextField("Add subject title")
            
            alertView.addButton("Add") {
                
                if subject.text != nil && subject.text != "" {
                    var notebook = Notebook()
                    notebook.created_at = Date()
                    notebook.subject = subject.text!
                    notebook.notebookStye = self.selectedStyle
                    DataService.shared.saveNewNotebook(notebook: notebook)
                    
//                    self.subjects.append(notebook)
//                    let indexPath = IndexPath(item: self.subjects.count - 1, section: 0)
//
//                    self.collectionView.performBatchUpdates({
//                        self.collectionView?.insertItems(at: [indexPath])
//                    }, completion: nil)
                    self.notebookLayoutView.isHidden = true
                    self.transparentView.isHidden = true
                } else {
                    self.errorAlert(title: "Error!", message: "You should fill the subject info")
                }
            }
            alertView.addButton("Change Style") {
                self.notebookLayoutView.isHidden = false
                alertView.dismiss(animated: true, completion: nil)
            }
            
            alertView.addButton("Cancel") {
                self.notebookLayoutView.isHidden = true
                self.transparentView.isHidden = true
                alertView.dismiss(animated: true, completion: nil)
            }
            alertView.showEdit("Add new Subject", subTitle: "Fill the subject title information!")
            self.transparentView.isHidden = true
        }
    }
  
}

class SubjectsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: CornerView!
    @IBOutlet weak var notebookImage: UIImageView!
    @IBOutlet weak var subjectTitleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                backView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
                setBackView()
            }
            else {
              backView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
                setBackView()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setBackView()
    }
    
    private func setBackView(){
        backView.layer.cornerRadius = 10
    }
}

class NotebookLayoutCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var notebookImage: UIImageView!
}
