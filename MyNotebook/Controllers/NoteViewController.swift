//
//  NoteViewController.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/24/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit
import Sketch
import ExpandingMenu

class NoteViewController: UIViewController {
    
    @IBOutlet weak var drawToolsView: UIView!
    
    @IBOutlet weak var eraserWidthView: UIView!
    @IBOutlet weak var penColorView: UIView!
    
    @IBOutlet weak var pencilColorView: UIView!
    @IBOutlet weak var markerColorView: UIView!
    @IBOutlet weak var lineWidthView: UIView!
    @IBOutlet weak var pagesCollectionView: UICollectionView!
    @IBOutlet weak var notePaperCollectionView: UICollectionView!
    @IBOutlet weak var penColorsCollectionView: UICollectionView!
    @IBOutlet weak var penColorsView: UIView!
    @IBOutlet weak var newNoteView: UIView!
    @IBOutlet weak var sketchView: SketchView!
    @IBOutlet weak var backgroundPaper: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var strokeSlider: UISlider!
    @IBOutlet var lineWidthButtons: [UIButton]!
    @IBOutlet var eraserWidthButton: [UIButton]!
    
    @IBOutlet var drawToolsPickerButtons: [UIButton]!
    
    @IBOutlet var drawToolsColorPickerButtons: [UIButton]!
    
    
    var penColors: [UIColor] = [.black, .darkGray, .lightGray, .blue, .green, .red]
    
    var pensImage = ["pen_black", "pen_dark_gray", "pen_light_gray", "pen_blue", "pen_green", "pen_red"]
    
    var notePapers = ["blank", "notebook_paper", "squared_paper"]
    var papersName = ["Blank", "Notebook", "Squared"]
    var paperSelected : UIImage?
    var note: Note!
    var page = Page()
    var sourceVC = "New Note"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.penColorsView.isHidden = true
        self.penColorsCollectionView.delegate = self
        self.penColorsCollectionView.dataSource = self
        self.notePaperCollectionView.delegate = self
        self.notePaperCollectionView.dataSource = self
        self.pagesCollectionView.delegate = self
        self.pagesCollectionView.dataSource = self
        self.newNoteView.isHidden = true
        
        self.sketchView.lineWidth = 1
        self.createNewPage()
        setColorsViewsInitialState()
    }
    
    
    func setColorsViewsInitialState() {
        
        isPencilSelected = true
        isPenSelected = false
        isMarkerSelected = false
        isEraserSelected = false
        isLineWidthSelected = false
        isDrawToolSelected = false
        
        pencilColorView.isHidden  = true
        self.penColorView.isHidden = true
        self.markerColorView.isHidden = true
        self.lineWidthView.isHidden = true
        self.eraserWidthView.isHidden = true
        self.drawToolsView.isHidden = true
        self.newNoteView.isHidden = true
    }
    
    func createNewPage() {
        var newPage = Page()
        if note != nil {
            newPage.pageNumber = Int32(note.getNumberOfPages() + 1)
            self.note.notePages[newPage.pageNumber] = newPage
            self.page = newPage
        }
        else {
            print("Note is nil")
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        sketchView.clear()
        self.newNoteView.isHidden = true
        self.penColorsView.isHidden = true
    }
    
    @IBAction func newFileButtonTapped(_ sender: UIBarButtonItem) {
       
        self.pencilColorView.isHidden  = true
        self.penColorView.isHidden = true
        self.markerColorView.isHidden = true
        self.lineWidthView.isHidden = true
        self.eraserWidthView.isHidden = true
        self.drawToolsView.isHidden = true
        self.newNoteView.isHidden = true
        
        if sender.tag == 0 {
            self.newNoteView.isHidden = false
            sender.tag = 1
        }
        else {
            self.newNoteView.isHidden = true
            sender.tag = 0
        }

    }
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        self.newNoteView.isHidden = true
        self.penColorsView.isHidden = true

    }
    
    @IBAction func undoButtonTapped(_ sender: UIBarButtonItem) {
         sketchView.undo()
        self.newNoteView.isHidden = true
    }
    
    
    @IBAction func redoButtonTapped(_ sender: UIBarButtonItem) {
        sketchView.redo()
        self.newNoteView.isHidden = true
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
        
        page.noteImage = image
        
        DataService.shared.saveNewPage(page: self.page, note: self.note) { (pages) in
            self.note.notePages[self.page.pageNumber] = self.page
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPreview" {
            let destination = segue.destination as! PreviewNoteVC
            destination.note = self.note
        }
    }
    
    
    //MARK: EDIT BUTTONS
    
    @IBAction func pencilButtonTapped(_ sender: UIButton) {
        self.sketchView.drawTool = .pen
        self.sketchView.drawingPenType = .normal
        sketchView.lineColor = self.pencilColorSelected
        self.sketchView.lineWidth = CGFloat(pencilWidth)
        
        isPencilSelected = true
        isPenSelected = false
        isMarkerSelected = false
        isEraserSelected = false
        isLineWidthSelected = false
        isDrawToolSelected = false
        
        if pencilColorView.isHidden {
            pencilColorView.isHidden  = false
        }
        else {
            pencilColorView.isHidden  = true
        }
        
        self.penColorView.isHidden = true
        self.markerColorView.isHidden = true
        self.eraserWidthView.isHidden = true
        self.lineWidthView.isHidden = true
        self.drawToolsView.isHidden = true

        self.newNoteView.isHidden = true
    }
    
    @IBAction func penButtonSelected(_ sender: UIButton) {
        self.sketchView.drawTool = .pen
        self.sketchView.drawingPenType = .normal
        sketchView.lineColor = self.penColorSelected
        self.sketchView.lineWidth = CGFloat(penWidth)
        
        isPencilSelected = false
        isMarkerSelected = false
        isEraserSelected = false
        isLineWidthSelected = false
        isPenSelected = true
        isDrawToolSelected = false
        
        if self.penColorView.isHidden {
             self.penColorView.isHidden = false
        }
        else {
             self.penColorView.isHidden = true
        }
        
        pencilColorView.isHidden  = true
        self.markerColorView.isHidden = true
        self.eraserWidthView.isHidden = true
        self.lineWidthView.isHidden = true
        self.drawToolsView.isHidden = true
        self.newNoteView.isHidden = true
    }
    
    @IBAction func eraserButtonSelected(_ sender: UIButton) {
        self.sketchView.drawTool = .eraser
        
        isPencilSelected = false
        isPenSelected = false
        isMarkerSelected = false
        isEraserSelected = true
        isLineWidthSelected = false
        isDrawToolSelected = false
        
        if eraserWidthView.isHidden {
            self.eraserWidthView.isHidden = false
        }
        else {
            self.eraserWidthView.isHidden = true
        }
        
        pencilColorView.isHidden  = true
        self.penColorView.isHidden = true
        self.markerColorView.isHidden = true
        self.lineWidthView.isHidden = true
        self.drawToolsView.isHidden = true
        self.newNoteView.isHidden = true
    }
    
    @IBAction func markerButtonSelected(_ sender: UIButton) {
        self.sketchView.drawTool = .pen
        self.sketchView.drawingPenType = .blur
        sketchView.lineColor = self.markerColorSelected
        self.sketchView.lineWidth = CGFloat(markerWidth)
        
        isPencilSelected = false
        isPenSelected = false
        isEraserSelected = false
        isLineWidthSelected = false
        isMarkerSelected = true
        isDrawToolSelected = false
        
        if self.markerColorView.isHidden {
             self.markerColorView.isHidden = false
        }
        else {
             self.markerColorView.isHidden = true
        }
        
        pencilColorView.isHidden  = true
        self.penColorView.isHidden = true
        self.eraserWidthView.isHidden = true
        self.lineWidthView.isHidden = true
        self.drawToolsView.isHidden = true

        self.newNoteView.isHidden = true
    }
    
    @IBAction func lineWidthButtonSelected(_ sender: UIButton) {
        isPencilSelected = false
        isPenSelected = false
        isMarkerSelected = false
        isEraserSelected = false
        isLineWidthSelected = true
        isDrawToolSelected = false
        
        if self.lineWidthView.isHidden {
             self.lineWidthView.isHidden = false
        } else {
            
             self.lineWidthView.isHidden = true
        }
        
        
        pencilColorView.isHidden  = true
        self.penColorView.isHidden = true
        self.markerColorView.isHidden = true
        self.eraserWidthView.isHidden = true
        self.drawToolsView.isHidden = true

        self.newNoteView.isHidden = true
    }
    
    @IBAction func drawToolsTapped(_ sender: UIButton) {
        
        self.sketchView.lineColor = self.drawToolColorSelected
        isDrawToolSelected = true
        isPencilSelected = false
        isPenSelected = false
        isMarkerSelected = false
        isEraserSelected = false
        isLineWidthSelected = true
        
        if drawToolsView.isHidden {
            self.drawToolsView.isHidden = false
        }
        else {
            self.drawToolsView.isHidden = true
        }
        
        pencilColorView.isHidden  = true
        self.penColorView.isHidden = true
        self.markerColorView.isHidden = true
        self.eraserWidthView.isHidden = true
        self.newNoteView.isHidden = true
        self.lineWidthView.isHidden = true
    }
    
    //MARK: COLORS SETUP
    
    var markerColorSelected = #colorLiteral(red: 0.9333333333, green: 0.8666666667, blue: 0.01568627451, alpha: 0.578125)
    var pencilColorSelected = #colorLiteral(red: 0.2431372549, green: 0.231372549, blue: 0.2235294118, alpha: 1)
    var penColorSelected = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
    var drawToolColorSelected = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
    
    var pencilWidth = 1
    var penWidth = 1
    var markerWidth = 30
    var eraserWidth = 10
    
    var isPenSelected = true
    var isPencilSelected = false
    var isMarkerSelected = false
    var isEraserSelected = false
    var isLineWidthSelected = false
    var isDrawToolSelected = false
    
    //PEN COLORS
    @IBAction func penRedColorTapped(_ sender: UIButton) {
        self.penColorSelected = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
        sketchView.lineColor = self.penColorSelected
    }
    @IBAction func penGreenColorTapped(_ sender: UIButton) {
        self.penColorSelected = #colorLiteral(red: 0.3803921569, green: 0.7254901961, blue: 0, alpha: 1)
        sketchView.lineColor = self.penColorSelected
    }
    @IBAction func penBlueColorTapped(_ sender: UIButton) {
        self.penColorSelected = #colorLiteral(red: 0.08235294118, green: 0.4941176471, blue: 0.9921568627, alpha: 1)
        sketchView.lineColor = self.penColorSelected
    }
    @IBAction func penBlackColorTapped(_ sender: UIButton) {
        sketchView.lineColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
    }
    @IBAction func penOrangeColorTapped(_ sender: UIButton) {
        self.penColorSelected = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
        sketchView.lineColor = self.penColorSelected
    }
    @IBAction func penPinkColorTapped(_ sender: UIButton) {
        self.penColorSelected = #colorLiteral(red: 0.9647058824, green: 0, blue: 1, alpha: 1)
        sketchView.lineColor = self.penColorSelected
    }
    
    //PENCIL COLORS
    @IBAction func pencilLightGrayColor(_ sender: UIButton) {
        self.pencilColorSelected = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        sketchView.lineColor = self.pencilColorSelected
    }
    @IBAction func pencilGray(_ sender: UIButton) {
        self.pencilColorSelected = #colorLiteral(red: 0.3764705882, green: 0.3607843137, blue: 0.3450980392, alpha: 1)
        sketchView.lineColor = self.pencilColorSelected
    }
    @IBAction func pencilDarkGray(_ sender: UIButton) {
        self.pencilColorSelected = #colorLiteral(red: 0.2431372549, green: 0.231372549, blue: 0.2235294118, alpha: 1)
        sketchView.lineColor = self.pencilColorSelected
    }
    
    //MARKER COLORS
    @IBAction func markerYellowColor(_ sender: UIButton) {
        self.markerColorSelected = #colorLiteral(red: 0.9333333333, green: 0.8666666667, blue: 0.01568627451, alpha: 0.578125)
        sketchView.lineColor = self.markerColorSelected
    }
    @IBAction func markerOrangeColor(_ sender: UIButton) {
        self.markerColorSelected = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 0.5786601027)
        sketchView.lineColor = self.markerColorSelected
    }
    @IBAction func markerPinkColor(_ sender: UIButton) {
        self.markerColorSelected = #colorLiteral(red: 0.9647058824, green: 0, blue: 1, alpha: 0.5820847603)
        sketchView.lineColor = self.markerColorSelected
    }
    
    //LINE WIDTH
    
    @IBAction func lineWidthPointSelected(_ sender: UIButton) {
        self.sketchView.drawTool = .pen
        
//        self.sketchView.drawTool =
        
        var lineWidth = 1
        print("TAG \(sender.tag)")
        switch sender.tag {
        case 0:
            print("case 1")
            if (isPenSelected) {
                penWidth = 1
                lineWidth = penWidth
            }
            else if (isPencilSelected) {
                pencilWidth = 1
                lineWidth = pencilWidth
            }
            self.sketchView.lineWidth = 1
            break
        case 1:
            if (isPenSelected) {
                penWidth = 3
                lineWidth = penWidth
            }
            else if (isPencilSelected) {
                pencilWidth = 3
                lineWidth = pencilWidth
            }
            self.sketchView.lineWidth = 3
            break
        case 2:
            if (isPenSelected) {
                penWidth = 5
                lineWidth = penWidth
            }
            else if (isPencilSelected) {
                pencilWidth = 5
                lineWidth = pencilWidth
            }
            self.sketchView.lineWidth = 5
            break
        case 3:
            if (isPenSelected) {
                penWidth = 10
                lineWidth = penWidth
            }
            else if (isPencilSelected) {
                pencilWidth = 10
                lineWidth = pencilWidth
            }
            self.sketchView.lineWidth = 10
            break
        case 4:
            if (isPenSelected) {
                penWidth = 15
                lineWidth = penWidth
            }
            else if (isPencilSelected) {
                pencilWidth = 15
                lineWidth = pencilWidth
            }
            self.sketchView.lineWidth = 15
            break
        case 5:
            if (isPenSelected) {
                penWidth = 20
                lineWidth = penWidth
            }
            else if (isPencilSelected) {
                pencilWidth = 20
                lineWidth = pencilWidth
            }
            self.sketchView.lineWidth = 20
            break
        case 6:
            if (isPenSelected) {
                penWidth = 30
                lineWidth = penWidth
            }
            else if (isPencilSelected) {
                pencilWidth = 30
                lineWidth = pencilWidth
            }
            self.sketchView.lineWidth = 30
            break
        default:
            print("No Selection found!")
        }
        
    }
    
    //ERASER WIDTH
    @IBAction func eraserWidthSelected(_ sender: UIButton) {
        self.sketchView.drawTool = .eraser
   
        switch sender.tag {
        case 0:
            self.sketchView.lineWidth = 1
            eraserWidth = 1
            break
        case 1:
            self.sketchView.lineWidth = 3
            eraserWidth = 3
            break
        case 2:
            self.sketchView.lineWidth = 5
            eraserWidth = 5
            break
        case 3:
            self.sketchView.lineWidth = 10
            eraserWidth = 10
            break
        case 4:
            self.sketchView.lineWidth = 15
            eraserWidth = 15
            break
        case 5:
            self.sketchView.lineWidth = 20
            eraserWidth = 20
            break
        case 6:
            self.sketchView.lineWidth = 30
            eraserWidth = 30
            break
        default:
            print("No Selection found!")
        }
    }
    
    
    // DRAW TOOLS
    
    
    @IBAction func drawToolSelected(_ sender: UIButton) {
        
        let selected = sender.tag
        
        switch selected{
        case 0:
            print("case -> \(selected)")
            self.sketchView.drawTool = .ellipseStroke
            break
        case 1:
            print("case -> \(selected)")
            self.sketchView.drawTool = .rectangleStroke
            break
        case 2:
            self.sketchView.drawTool = .ellipseFill
            break
        case 3:
            self.sketchView.drawTool = .rectangleFill
            break
        case 4:
            self.sketchView.drawTool = .line
            break
        case 5:
            self.sketchView.drawTool = .arrow
            break
        default:
            self.sketchView.drawTool = .pen
        }
        
    }
    
    @IBAction func drawColorSelected(_ sender: UIButton) {
   
        let selectedColor = sender.tag
        
        switch selectedColor {
        case 0:
            self.drawToolColorSelected = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
            break
        case 1:
            self.drawToolColorSelected = #colorLiteral(red: 0.3764705882, green: 0.3607843137, blue: 0.3450980392, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.3764705882, green: 0.3607843137, blue: 0.3450980392, alpha: 1)
            break
        case 2:
            self.drawToolColorSelected = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
            break
        case 3:
            self.drawToolColorSelected = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1)
            break
        case 4:
            self.drawToolColorSelected = #colorLiteral(red: 0.3803921569, green: 0.7254901961, blue: 0, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.3803921569, green: 0.7254901961, blue: 0, alpha: 1)
            break
        case 5:
            self.drawToolColorSelected = #colorLiteral(red: 0.08235294118, green: 0.4941176471, blue: 0.9921568627, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.08235294118, green: 0.4941176471, blue: 0.9921568627, alpha: 1)
            break
        case 6:
            self.drawToolColorSelected = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1)
            break
        case 7:
            self.drawToolColorSelected = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.9607843137, green: 0.6509803922, blue: 0.137254902, alpha: 1)
            break
        case 8:
            self.drawToolColorSelected = #colorLiteral(red: 0.9647058824, green: 0, blue: 1, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.9647058824, green: 0, blue: 1, alpha: 1)
            break
        default:
            self.drawToolColorSelected = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
            sketchView.lineColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
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
            
            let page = note.notePages[Int32(index)]
            cell.paperStyle.image = page?.noteImage
           
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
            print("Selecting paper type")
            self.paperSelected = UIImage(named: notePapers[indexPath.row])
            self.backgroundPaper.image = self.paperSelected
            self.newNoteView.isHidden = true
            self.addNewPage()
        }
    }
    
    private func addNewPage() {
        takeScreenshot(view: self.backView)
        sketchView.clear()
        
        //Save the current Page changes
        self.note.notePages[self.page.pageNumber] = page
        
        //Create a new Page
        self.createNewPage()
    }
    
    
}


class PensColorsCollectionCell: UICollectionViewCell {
    
   
    @IBOutlet weak var colorView: CircleView!

}

class NotePapersCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var paperStyle: UIImageView!
    @IBOutlet weak var paperStyleName: UILabel!
}
