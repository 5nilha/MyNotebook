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
    
    var selectedNote: Note!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        if let notebook = self.notebook {
            navigationItem.title = "\(notebook.subject)"
            DataService.shared.fetchNotes(notebook: notebook) { (noteData) in
                self.notebook.notes = noteData
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func newNoteButtonTapped(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
 
        
        let title = alertView.addTextField("Note Title")
        
        alertView.addButton("Done") {
            
            if title.text != nil && title.text != "" {
                let note = Note(title: title.text!, created_at: Date())
                note.saveNote(to: self.notebook)
                self.notebook.notes.append(note)
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
            destination.note = self.selectedNote
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        self.selectedNote = notebook.notes[index]
        
        DataService.shared.fetchPages(note: self.selectedNote) { (pagesData) in
            for page in pagesData {
                self.selectedNote.notePages[page.pageNumber] = page
            }

            if (pagesData.count > 0) {
                self.performSegue(withIdentifier: "goToPagesPreview", sender: self)
            } else {
                self.performSegue(withIdentifier: "goToNewNote", sender: self)
            }
        }
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
