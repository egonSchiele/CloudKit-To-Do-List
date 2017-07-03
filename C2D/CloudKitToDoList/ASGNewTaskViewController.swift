//
//  ASGNewTaskViewController.swift
//  CloudKitToDoList
//
//  Created by Anthony Geranio on 1/15/15.
//  Copyright (c) 2015 Sleep Free. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class ASGNewTaskViewController: UIViewController, UITableViewDelegate, UITextViewDelegate {

    // UITextView for task description.
    @IBOutlet var taskDescriptionTextView: UITextView!
    
    // Function to add a task to the iCloud database
    func addTask() {
        
        navigationController?.popViewController(animated: true)
        
        // Create record to save tasks
        var record: CKRecord = CKRecord(recordType: "task")
        // Save task description for key: taskKey
        record.setObject(self.taskDescriptionTextView.text as CKRecordValue?, forKey: "taskKey")
        // Create the private database for the user to save their data to
        var database: CKDatabase = CKContainer.default().privateCloudDatabase
        
        // Save the data to the database for the record: task
        func recordSaved(_ record: CKRecord?, error: NSError?) {
            if (error != nil) {
                // handle it
                
            }
        }
        
        // Save data to the database for the record: task
        database.save(record, completionHandler: recordSaved as! (CKRecord?, Error?) -> Void)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        // Create done button to add a task
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ASGNewTaskViewController.addTask))
        self.navigationItem.rightBarButtonItem = doneButton
        
        self.taskDescriptionTextView.becomeFirstResponder()

    }
    
}
