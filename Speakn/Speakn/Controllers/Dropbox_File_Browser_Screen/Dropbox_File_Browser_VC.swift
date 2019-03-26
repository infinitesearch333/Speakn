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
    @IBOutlet weak var parent_folder_label: UILabel!
    
    // MARK: Internal elements
    var dispatch_group: DispatchGroup!
    var dropbox_file_browser: Dropbox_File_Browser!
    var currentObject: Dropbox_Object!
    var selected_presentation_file_path: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up file browser user interface
        self.file_browser_table_view.delegate = self
        self.file_browser_table_view.dataSource = self
        self.file_browser_table_view.tableFooterView = UIView()
        self.file_browser_table_view.backgroundView = self.file_browser_table_view_background
        self.file_browser_table_view.backgroundView?.isHidden = true
        
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
        
        // Setting up parent folder label
        let current_object_path = self.currentObject.path.split(separator: "/")
        
        if current_object_path.count == 0 {
            self.parent_folder_label.text = "Dropbox"
            
        } else {
            self.parent_folder_label.text = "\(current_object_path[current_object_path.endIndex - 1])"
        }
        
        // Determining if tableview is empty in order to present empty folder message
        if self.currentObject.children_ids.count == 0 {
            self.file_browser_table_view.backgroundView?.isHidden = false
            
        } else {
            self.file_browser_table_view.backgroundView?.isHidden = true
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
//            DropboxClientsManager.unlinkClients()
            DropboxClientsManager.unlinkClients()
            
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
            let dropbox_object_id = self.currentObject.children_ids[indexPath.row]
            self.present_file_confimation_alert_view_controller(selected_dropbox_object_id: dropbox_object_id)
            
        case . Unknown:
            self.present_incorrect_file_alert_view_controller()
        }
       
        // Remove table cell highlight after click
        self.file_browser_table_view.deselectRow(at: indexPath, animated: false)
    }
    
    func present_file_confimation_alert_view_controller(selected_dropbox_object_id: Int){
        let alert_view_controller = UIAlertController(title: "Does this file contain your presentations?", message: nil, preferredStyle: .alert)
        
        let alert_action_one = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert_view_controller.addAction(alert_action_one)
        
        let alert_action_two = UIAlertAction(title: "Continue", style: .default)
        { (_) in
            self.selected_presentation_file_path = self.dropbox_file_browser.directory[selected_dropbox_object_id].path
            self.performSegue(withIdentifier: "Presentation_Setup_Loading_Screen_Segue", sender: nil)
        }
        alert_view_controller.addAction(alert_action_two)
        
        present(alert_view_controller, animated: true, completion: nil)
    }
    
    func present_incorrect_file_alert_view_controller(){
        let alert_view_controller = UIAlertController(title: "Invalid File", message: "Presentation files are of type .csv", preferredStyle: .alert)
        
        let alert_action = UIAlertAction(title: "Continue", style: .default, handler: nil)
        alert_view_controller.addAction(alert_action)
        
        present(alert_view_controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination_view_controller = segue.destination as! Presentation_Setup_Loading_Screen_VC
        destination_view_controller.presentations_file_path = self.selected_presentation_file_path
    }
}
