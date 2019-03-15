//
//  Dropbox_Object_Cell.swift
//  Speakn
//
//  Created by Sergio Rosendo on 3/12/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

class Dropbox_Object_Cell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func setup(dropbox_object: Dropbox_Object) {
        // Setting up title
        let object_path = dropbox_object.path.split(separator: Character("/"))
        let object_title = object_path.last
        self.title.text = "\(object_title ?? "")"
        
        // Setting up icon
        switch dropbox_object.type {
        case .Folder:
            self.icon.image = UIImage(named: "Folder_Icon")
            
        case .CSV_File:
            self.icon.image = UIImage(named: "CSV_File_Icon")
            
        case .Unknown:
            self.icon.image = UIImage(named: "Unknown_File_Icon")
        }
    }
}
