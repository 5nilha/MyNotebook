//
//  DataService.swift
//  MyNotebook
//
//  Created by Fabio Quintanilha on 12/29/18.
//  Copyright © 2018 Fabio Quintanilha. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataService {
    
    private init (){}
    static let shared = DataService()
    
    let persistence: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func saveData() {
        do {
            try self.persistence.save()
            
        } catch {
            print(error.localizedDescription)
            return
        }
        print("Saved Data")
    }
    
    
    //MARK:-> -------- NOTEBOOK DATA SERVICES---------------
    
    //Adding a new Notebook to CoreData
    func saveNewNotebook(notebook: Notebook) {
        let newNotebookItem = Notebooks(context: persistence)
        newNotebookItem.subject = notebook.subject
        newNotebookItem.created_at = notebook.created_at
        newNotebookItem.cover = notebook.notebookStye?.UIImageToData(compressionRatio: 1.0)
//        newNotebookItem.notebook_uid = "\(newNotebookItem.objectID)"
    
       self.saveData()
    }
    
    
    // Fetching Notebooks from CoreData
    func fetchNotebooksData(completion: @escaping ([Notebook]) -> ()) {
        let notebookRequest: NSFetchRequest<Notebooks> = Notebooks.fetchRequest()
        notebookRequest.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(key: "subject", ascending: true)
        notebookRequest.sortDescriptors = [sortDescriptor]
        
        var notebookDataArray = [Notebooks]()
        
        do {
            notebookDataArray = try persistence.fetch(notebookRequest)
         
        } catch {
            print(error)
            return
        }
        
        var notebooks = [Notebook]()
        print("Counting notebooks \(notebookDataArray.count)" )
        for notebookData in notebookDataArray {
            
            var notebook = Notebook()
            
            let created_at = notebookData.created_at ?? Date()
            let subject = notebookData.subject ?? ""
            
            print("Notebook -> \(subject)")
            notebook.created_at = created_at
            notebook.subject = subject
            notebook.object = notebookData
            
            if let coverImage = notebookData.cover {
                let cover = UIImage(data: coverImage, scale: 1.0)
                notebook.notebookStye = cover
            } else {
                notebook.notebookStye = UIImage(named: "notebook_black")
            }
            
            notebooks.append(notebook)
        }
        
        completion(notebooks)
    }
    
    //MARK:-> -------- NOTES DATA SERVICES---------------
    
    //Adding a new Note to CoreData
    func  saveNewNote(note: Note, notebook: Notebook) {
        
        let newNoteItem = Notes(context: persistence)
        newNoteItem.created_at = note.created_at
        newNoteItem.title = note.title
        newNoteItem.number_of_pages = note.getNumberOfPages()
        notebook.object.addToNotes(newNoteItem)
        
        self.saveData()
    }
    
    
    //Fetching notes from CoreData
    func fetchNotes(notebook: Notebook, completion: @escaping ([Note]) -> ()) {
        let notebookObject = notebook.object
        print("fetching notes")
        
        if let notebookObject = notebookObject {
            
            let orderedNoteList: NSMutableOrderedSet = notebookObject.mutableOrderedSetValue(forKey: "notes")
            
            let notesData = orderedNoteList.array as! [Notes]
            print("Notes count = \(notesData.count)")
            
            var notes = [Note]()
            for noteData in notesData {
  
                let title = noteData.title ?? ""
                let created_at = noteData.created_at ?? Date()
                let note = Note(title: title, created_at: created_at)
                note.noteObject = noteData
                notes.append(note)
            }
            
            completion(notes)
            
        } else {
            print("notebookObject doesn't exist")
        }
    }
    
    
    //MARK:-> -------- PAGES DATA SERVICES---------------
    
    //Adding a new Page to CoreData
    func saveNewPage(page: Page, note: Note) {
        let pageItem = Pages(context: persistence)
        pageItem.note_image = page.noteImage.UIImageToData(compressionRatio: 1.0)
        pageItem.page_number = page.pageNumber
        note.noteObject.addToPages(pageItem)
        
        self.saveData()
    }
    
    
    //Fetching notes from CoreData
    func fetchPages(note: Note, completion: @escaping ([Page]) -> ()) {
        let noteObject = note.noteObject
        print("fetching pages on \(noteObject?.title)")
        
        if let noteObject = noteObject {

            let orderedNoteList: NSMutableOrderedSet = noteObject.mutableOrderedSetValue(forKey: "pages")

            let pagesData = orderedNoteList.array as! [Pages]
            print("Pages count = \(pagesData.count)")

            var pages = [Page]()
            for pageData in pagesData {

                let pageNumber = pageData.page_number

                var page = Page()
                page.pageNumber = pageNumber

                if let pageContent = pageData.note_image {
                    page.noteImage = UIImage(data: pageContent, scale: 1.0)
                }

                page.pageObject = pageData
                pages.append(page)
            }
            completion(pages)

        } else {
            print("notebookObject doesn't exist")
        }
    }
    
    
    
    // MARK: Delete Data Records
    
    //Delete all records
    func deleteNotebookRecords() -> Void {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notebooks")
        
        let result = try? persistence.fetch(fetchRequest)
        let resultData = result as! [Notebooks]
        
        for object in resultData {
            persistence.delete(object)
        }
        
        do {
            try persistence.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    
    
}


