//
//  NoteViewController.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/24/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit
import Sketch

class NoteViewController: UIViewController {

    
    @IBOutlet weak var pagesCollectionView: UICollectionView!
    
    @IBOutlet weak var notePaperCollectionView: UICollectionView!
    @IBOutlet weak var penColorsCollectionView: UICollectionView!
    @IBOutlet weak var topMenuView: UIView!
    @IBOutlet weak var penColorsView: UIView!
    @IBOutlet weak var newNoteView: UIView!
    @IBOutlet weak var sketchView: SketchView!
    @IBOutlet weak var backgroundPaper: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var strokeSlider: UISlider!
    
    var penColors: [UIColor] = [.black, .darkGray, .lightGray, .blue, .green, .red]
    
    var pensImage = ["pen_black", "pen_dark_gray", "pen_light_gray", "pen_blue", "pen_green", "pen_red"]
    
    var notePapers = ["blank", "notebook_paper", "squared_paper"]
    var papersName = ["Blank", "Notebook", "Squared"]
    var paperSelected : UIImage?
    var note: Note!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.penColorsView.isHidden = true
        self.topMenuView.isHidden = false
        self.penColorsCollectionView.delegate = self
        self.penColorsCollectionView.dataSource = self
        self.notePaperCollectionView.delegate = self
        self.notePaperCollectionView.dataSource = self
        self.pagesCollectionView.delegate = self
        self.pagesCollectionView.dataSource = self
        self.newNoteView.isHidden = true
        
            self.sketchView.lineWidth = CGFloat(1.0)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
        
        if sender.tag == 0 {
            self.penColorsView.isHidden = false
            self.penColorsCollectionView.isHidden = false
            sender.tag = 1
        }
        else {
            self.penColorsView.isHidden = true
            self.penColorsCollectionView.isHidden = false
            sender.tag = 0
        }
        
        
        self.newNoteView.isHidden = true
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        sketchView.clear()
        self.newNoteView.isHidden = true
        self.penColorsView.isHidden = true
    }
    
    
    @IBAction func eraseButtonTapped(_ sender: UIButton) {
        self.penColorsView.isHidden = false
        self.penColorsCollectionView.isHidden = true

        self.newNoteView.isHidden = true
        
        if sender.tag == 0 {
            self.sketchView.drawTool = .eraser
            self.penColorsView.isHidden = false
            self.penColorsCollectionView.isHidden = true
            sender.tag = 1
        }
        else {
            self.sketchView.drawTool = .pen
             self.penColorsView.isHidden = true
            self.penColorsCollectionView.isHidden = false
            sender.tag = 0
        }
    }
    
    @IBAction func newFileButtonTapped(_ sender: UIButton) {
        self.penColorsView.isHidden = true
        
        if sender.tag == 0 {
            self.newNoteView.isHidden = false
            sender.tag = 1
        }
        else {
            self.newNoteView.isHidden = true
            sender.tag = 0
        }

    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.newNoteView.isHidden = true
        self.penColorsView.isHidden = true

    }
    
    @IBAction func undoButtonTapped(_ sender: UIButton) {
         sketchView.undo()
        self.newNoteView.isHidden = true
    }
    
    
    @IBAction func redoButtonTapped(_ sender: UIButton) {
        sketchView.redo()
        self.newNoteView.isHidden = true
    }
    
    @IBAction func addPageButtonTapped(_ sender: UIButton) {
        takeScreenshot(view: self.backView)
        sketchView.clear()
    }
    
    
    
    
    @IBAction func strokeSliderChanged(_ sender: UISlider) {
        let strokeWidth = sender.value
        
        self.sketchView.lineWidth = CGFloat(strokeWidth)
    }
    
    @IBAction func shrinkPenColorViewTapped(_ sender: UIButton) {
        self.penColorsView.isHidden = true
    }
    
    
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        takeScreenshot(view: self.backView)
    }
    
    @IBAction func previewButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "goToPreview", sender: self)
    }
    
    
    func takeScreenshot(view: UIView)  {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        note.noteImage = image
        note.notePages.append(image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPreview" {
            let destination = segue.destination as! PreviewNoteVC
            destination.note = self.note
        }
    }
    
}

extension NoteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == penColorsCollectionView {
            return self.penColors.count
        }
        else if collectionView == notePaperCollectionView {
            return self.notePapers.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == penColorsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PensColorsCollectionCell", for: indexPath) as! PensColorsCollectionCell
            
            
            let index = indexPath.row
            
            cell.colorView.backgroundColor = penColors[index]
            
            return cell
        }
        else if collectionView == pagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotePapersCollectionCell", for: indexPath) as! NotePapersCollectionCell
            
            
            let index = indexPath.row
            
            cell.paperStyle.image = note.notePages[index]
           
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotePapersCollectionCell", for: indexPath) as! NotePapersCollectionCell
            
            
            let index = indexPath.row
            
            cell.paperStyle.image = UIImage(named: notePapers[index])
            cell.paperStyleName.text = self.papersName[index]
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == penColorsCollectionView {
            let index = indexPath.row
            sketchView.lineColor = penColors[index]
        }
        else {
            self.paperSelected = UIImage(named: notePapers[indexPath.row])
            self.backgroundPaper.image = self.paperSelected
            self.newNoteView.isHidden = true
        }
    }
    
    
}


class PensColorsCollectionCell: UICollectionViewCell {
    
   
    @IBOutlet weak var colorView: CircleView!

}

class NotePapersCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var paperStyle: UIImageView!
    @IBOutlet weak var paperStyleName: UILabel!
}
