//
//  ASGTableViewController.swift
//  CloudKitToDoList
//
//  Created by Anthony Geranio on 1/15/15.
//  Copyright (c) 2015 Sleep Free. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class ASGTableViewController: UITableViewController {
    
    // Crete an array to store the tasks
    var tasks: NSMutableArray = NSMutableArray()
    // Create a CKRecord for the items in our database we will be retreiving and storing
    var items: [CKRecord] = []
    
    // Function to load all tasks in the UITableView and database
    func loadTasks() {
        
        // Create the query to load the tasks
        var query = CKQuery(recordType: "task", predicate: NSPredicate(format: "TRUEPREDICATE"))
        var queryOperation = CKQueryOperation(query: query)
        
        print("Start fetch")
        
        // Fetch the items for the record
        func fetched(_ record: CKRecord!) {
            items.append(record)
        }
        
        queryOperation.recordFetchedBlock = fetched
        
        // Finish fetching the items for the record
      func fetchFinished(block:(_ cursor: CKQueryCursor?, _: Error?) -> Void?) {
            
        
            print("End fetch")
            
            // Print items array contents
            print(items)
            
            // Add contents of the item array to the tasks array
            tasks.addObjects(from: items)
            
            // Reload the UITableView with the retreived contents
            self.tableView?.reloadData()
        }
        
        
        //queryOperation.queryCompletionBlock = fetchFinished
        
        // Create the database you will retreive information from
        var database: CKDatabase = CKContainer.default().privateCloudDatabase
        database.add(queryOperation)
        
    }
    
    // Function to delete all tasks in the UITableView and database
    func deleteTasks() {
        
        // Create the query to load the tasks
        var query = CKQuery(recordType: "task", predicate: NSPredicate(format: "TRUEPREDICATE"))
        var queryOperation = CKQueryOperation(query: query)
        print("Begin deleting tasks")
        
        // Fetch the items for the record
        func fetched(_ record: CKRecord!) {
            items.append(record)
        }
        
        queryOperation.recordFetchedBlock = fetched
        
        
        // Finish fetching the items for the record
        func fetchFinished(_ cursor: CKQueryCursor?, error: NSError?) {
            
            if error != nil {
                print(error)
            }
            
            print("All tasks have been deleted")
            
            // Print items array contents
            print(items)
            
            // Iterate through the array content ids
            var ids : [CKRecordID] = []
            for i in items {
                ids.append(i.recordID)
            }
            
            // Create the database where you will delete your data from
            var database: CKDatabase = CKContainer.default().privateCloudDatabase
            
            // Reload the UITableView with the retreived contents
            self.tableView!.reloadData()
            
        }
        
        //queryOperation.queryCompletionBlock = fetchFinished
        
        // Create the database where you will retreive your new data from
        var database: CKDatabase = CKContainer.default().privateCloudDatabase
        database.add(queryOperation)
    }
    
    // MARK: UITableView Delegate Methods
    override func numberOfSections(in tableView: UITableView?) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        print(tasks)
        
        var task: CKRecord = tasks[indexPath.row] as! CKRecord
        
        // Set the main cell label for the key we retreived: taskKey. This can be optional.
        if let text = task.object(forKey: "taskKey") as? String {
            cell.textLabel?.text = text
        }

        return cell as UITableViewCell
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Deselect the row using an animation.
        self.tableView?.deselectRow(at: indexPath, animated: true)
        
        // Reload the row using an animation.
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.top)
        
    }
    
    // MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
        
        loadTasks()
        self.tableView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Create delete button to delete all tasks
        let deleteButton: UIBarButtonItem = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ASGTableViewController.deleteTasks))
        self.navigationItem.leftBarButtonItem = deleteButton
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
