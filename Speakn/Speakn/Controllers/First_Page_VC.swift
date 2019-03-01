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
    }
    
    // MARK: UI Functionality
    @IBAction func dropbox_button_pressed(_ sender: UIButton) {
        setup_with_dropbox()
    }
    
    // MARK: Helper functions
    func setup_with_dropbox(){
        // Start Dropbox OAuth2 process via app or website if necessary
        let dropbox_client = DropboxClientsManager.authorizedClient
        if dropbox_client == nil {
            DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self)
            { (url: URL) in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        // Redirect user to Dropbox file browser if OAuth2 process was successfully completed
        print("OAuth2 process was successfully completed")
        performSegue(withIdentifier: "Dropbox_File_Browser_Segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Dropbox_File_Browser_Segue" {
            let destinationController = segue.destination as! Dropbox_File_Browser_VC
            destinationController.dropbox_client = DropboxClientsManager.authorizedClient
        }
    }
}
