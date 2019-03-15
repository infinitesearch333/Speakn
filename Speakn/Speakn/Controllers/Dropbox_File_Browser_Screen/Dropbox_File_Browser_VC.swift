//
//  Dropbox_File_Browser_VC.swift
//  Speakn
//
//  Created by Sergio Rosendo on 3/1/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit
import SwiftyDropbox

class Dropbox_File_Browser_VC: UIViewController {
    // MARK: User interface elements
    @IBOutlet weak var file_browser_table_view: UITableView!
    @IBOutlet weak var file_browser_table_view_background: UIView!
    
    // MARK: Internal elements
    var dispatch_group: DispatchGroup!
    var dropbox_file_browser: Dropbox_File_Browser!
    var currentObject: Dropbox_Object!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up file browser user interface
        self.file_browser_table_view.delegate = self
        self.file_browser_table_view.dataSource = self
        self.file_browser_table_view.tableFooterView = UIView()
        
        // Setup file browser
        self.dispatch_group = DispatchGroup()
        self.dropbox_file_browser = Dropbox_File_Browser(dispatch_group: self.dispatch_group)
        
        // Complete file browser user interface setup after file browser setup is completed
        self.dispatch_group.notify(queue: .main) {
            self.setup_file_browser_table_view(current_object_id: 0)
        }
    }
    
    
    /// Function determines how the file broswer user interface should be displayed
    func setup_file_browser_table_view(current_object_id: Int){
        self.currentObject = self.dropbox_file_browser.directory[current_object_id]
        
        if self.currentObject.children_ids.count == 0 {
            self.file_browser_table_view.backgroundView = self.file_browser_table_view_background
            
        } else {
            self.file_browser_table_view.backgroundView = nil
        }
        
        self.file_browser_table_view.reloadData()
    }
    
    
    // MARK: User interface functionality
    @IBAction func back_button_pressed(_ sender: UIButton) {
        if let current_object_parent_id = self.currentObject.parent_id {
            setup_file_browser_table_view(current_object_id: current_object_parent_id)
            
        } else {
            self.presentLogoutAlertViewController()
        }
    }
    
    
    func presentLogoutAlertViewController() {
        let alert_view_controller = UIAlertController(title: "Log out of Dropbox?", message: nil, preferredStyle: .alert)
        
        let action_one = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert_view_controller.addAction(action_one)
        
        let action_two = UIAlertAction(title: "Log Out", style: .default)
        { (_) in
            DropboxClientsManager.authorizedClient = nil
            self.dismiss(animated: true, completion: nil)
        }
        
        alert_view_controller.addAction(action_two)
        
        self.present(alert_view_controller, animated: true, completion: nil)
    }
}



extension Dropbox_File_Browser_VC: UITableViewDelegate, UITableViewDataSource {
    // Function determines how many cells should be displayed in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0

        if currentObject != nil {
            count = self.currentObject.children_ids.count
        }
        
        return count
    }
    
    
    // Function sets up table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dropbox_object = self.dropbox_file_browser.directory[self.currentObject.children_ids[indexPath.row]]
        let dropbox_object_cell = tableView.dequeueReusableCell(withIdentifier: "Dropbox_Object_Cell") as! Dropbox_Object_Cell
        
        dropbox_object_cell.setup(dropbox_object: dropbox_object)
        
        return dropbox_object_cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Obtaining selected Dropbox object
        let dropbox_object = self.dropbox_file_browser.directory[self.currentObject.children_ids[indexPath.row]]
        
        // Select action based on Dropbox object type
        switch dropbox_object.type {
        case .Folder:
            self.setup_file_browser_table_view(current_object_id: self.currentObject.children_ids[indexPath.row])
        case .CSV_File:
            self.present_file_confimation_alert_view_controller()
        case . Unknown:
            self.present_incorrect_file_alert_view_controller()
        }
       
    }
    
    func present_file_confimation_alert_view_controller(){
        let alert_view_controller = UIAlertController(title: "Does this file contain your presentations?", message: nil, preferredStyle: .alert)
        
        let alert_action_one = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert_view_controller.addAction(alert_action_one)
        
        let alert_action_two = UIAlertAction(title: "Continue", style: .default, handler: nil)
        alert_view_controller.addAction(alert_action_two)
        
        present(alert_view_controller, animated: true, completion: nil)
    }
    
    func present_incorrect_file_alert_view_controller(){
        let alert_view_controller = UIAlertController(title: "Invalid File", message: "Presentation files are of type .csv", preferredStyle: .alert)
        
        let alert_action = UIAlertAction(title: "Continue", style: .default, handler: nil)
        alert_view_controller.addAction(alert_action)
        
        present(alert_view_controller, animated: true, completion: nil)
    }
}
