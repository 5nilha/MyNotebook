//
//  PreviewNoteVC.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/26/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

class PreviewNoteVC: UIViewController, UIDocumentInteractionControllerDelegate {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    var note : Note!
    var sourceVC = ""
    var selectedPage : Page!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
//        print("pages: \(note.notePages.count)")
    }
    
    
    @IBAction func addNewPage(_ sender: UIBarButtonItem) {
        
        if sourceVC == "Notes" {
            self.performSegue(withIdentifier: "goToNewPage", sender: self)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func sharePage(_ sender: UIBarButtonItem) {
        
        
        let pdfDocument = PDFDocument()
        let pagesCount = self.note.notePages.count
        var pdfIndex = 0

        for pageNumber in 1...pagesCount {
            let page = self.note.notePages[Int32(pageNumber)]
            let pageImage = page?.noteImage
            let pdfPage = PDFPage(image: pageImage!)
            pdfDocument.insert(pdfPage!, at: pdfIndex)
            pdfIndex += 1
        }
        let data = pdfDocument.dataRepresentation()
        
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = "\(documentPath)/\(note.title).pdf"
        
        let url = URL(fileURLWithPath: path)
        

        try? data!.write(to: url)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        print("directory \(documentsDirectory)")
        let urlShown = URL(fileURLWithPath: documentsDirectory)
        sharePagesContent()
    }

    func showSavedPdf(url: String, fileName:String) {
        
        
        
//        let webview = WKWebView(frame: UIScreen.main.bounds)
//        view.addSubview(webview)
//        print("reading pdf file !!!!!!!")
//        do {
//            let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
//            for url in contents {
//                if url.description.contains("\(fileName).pdf") {
//
//                    if let pdf = Bundle.main.url(forResource: "\(fileName)", withExtension: "pdf", subdirectory: nil, localization: nil)  {
//                        let req = NSURLRequest(url: pdf)
//                        webview.load(req as URLRequest)
//                    }
//
//                }
//            }
//        } catch {
//            print("could not locate pdf file !!!!!!!")
//        }
    }
    
    // check to avoid saving a file multiple times
    func pdfFileAlreadySaved(url:String, fileName:String)-> Bool {
        var status = false
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName).pdf") {
                        status = true
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
        return status
    }
    
    
    func sharePagesContent() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        print("directory \(documentsDirectory)")
        let url = URL(fileURLWithPath: documentsDirectory)
        
        let controller = UIDocumentInteractionController(url: url)
        controller.delegate = self
        controller.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    
    func shareImagePage() {
        
        if let page = self.selectedPage {
            let image = page.noteImage
            let items = [image]
            
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.view
            
            activityController.completionWithItemsHandler = { (nil, completed, _, error)
                in
                if completed {
                    print("Completed")
                }
                else {
                    print("Canceled")
                }
            }
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewPage" {
            let destination = segue.destination as! NoteViewController
            destination.note = self.note
            destination.sourceVC = self.sourceVC
        }
    }
    
}

extension PreviewNoteVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return note.notePages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotePagesCollectionCell", for: indexPath) as! NotePagesCollectionCell
        
        let index = indexPath.row + 1
        
        let page = note.notePages[Int32(index)]
        
        cell.noteImage.image = page?.noteImage
        cell.pageNumber.text = "\(page?.pageNumber ?? 0)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.row + 1
        self.selectedPage = note.notePages[Int32(index)]
        shareImagePage()
    }
}



class NotePagesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var pageNumber: UILabel!
    
    
}
