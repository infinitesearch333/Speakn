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
    // Dropbox client will be setup by prepare segue function in first page
    var dropbox_client: DropboxClient! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
