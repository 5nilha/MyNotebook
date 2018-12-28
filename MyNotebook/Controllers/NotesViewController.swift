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

    @IBOutlet weak var tableView: UITableView!
    
    var notebook: Notebook!
    var newNote : Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        if let notebook = self.notebook {
            navigationItem.title = "\(notebook.subject)"
        }
    }
    
    @IBAction func newNoteButtonTapped(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
 
        
        let title = alertView.addTextField("Note Title")
        
        alertView.addButton("Done") {
            
            if title.text != nil && title.text != "" {
                let note = Note(subject_uid: self.notebook.uid, subject: self.notebook.subject, title: title.text!, date: Date())
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

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as! NotesTableViewCell
        
        let note = notebook.notes[indexPath.row]
        cell.updateCell(note: note)
        return cell
    }
    
    
}


class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    
    
    
    func updateCell(note: Note) {
        self.noteNameLabel.text = note.title
        self.pageLabel.text = "Pages: \(note.getNumberOfPages())"
    }
    
}
