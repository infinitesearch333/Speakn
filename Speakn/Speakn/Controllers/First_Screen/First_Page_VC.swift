//
//  First_Page_VC.swift
//  Speakn
//
//  Created by Sergio Rosendo on 3/1/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit
import SwiftyDropbox

class First_Page_VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
    }
    
    // MARK: UI Functionality
    @IBAction func dropbox_button_pressed(_ sender: UIButton) {
        setup_with_dropbox()
    }
    
    
    
    // MARK: Helper functions
    func setup_with_dropbox(){
        let dropbox_client = DropboxClientsManager.authorizedClient
        
        if dropbox_client == nil {
            // Start Dropbox OAuth2 process via app or website
            DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self)
            { (url: URL) in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        } else {
            // Redirect user to Dropbox file browser if OAuth2 was already completed
            performSegue(withIdentifier: "Dropbox_File_Browser_Segue", sender: nil)
        }
    }
    
    
    // MARK: Observers
    func setupObservers(){
        // Observer will present Dropbox file browser when notified that user successfully completed OAuth2 process
        let present_db_file_browser = Notification.Name(rawValue: "present_db_file_browser")
        NotificationCenter.default.addObserver(self, selector: #selector(First_Page_VC.presentViewController(notification:)), name: present_db_file_browser, object: nil)
    }
    
    @objc func presentViewController(notification: NSNotification){
        if notification.name.rawValue == "present_db_file_browser" {
            performSegue(withIdentifier: "Dropbox_File_Browser_Segue", sender: nil)
        }
    }
}
