//
//  NotesViewController.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/25/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import UIKit
import SCLAlertView

class NotesViewController: UIViewController {

    
    let newPage = 0

    var newNote : Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newNoteButtonTapped(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
 
        
        let title = alertView.addTextField("Note Title")
        
        alertView.addButton("Done") {
            
            if title.text != nil && title.text != "" {
                let note = Note(title: title.text!, date: Date(), pageNumber: self.newPage)
                self.newNote = note
                
                self.performSegue(withIdentifier: "goToNewNote", sender: self)
            }
            
            alertView.dismiss(animated: true, completion: nil)
        }
        
        alertView.showEdit("New Note", subTitle: "Add the note's title.")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewNote" {
            let destination = segue.destination as! NoteViewController
            destination.note = self.newNote
        }
    }

}
