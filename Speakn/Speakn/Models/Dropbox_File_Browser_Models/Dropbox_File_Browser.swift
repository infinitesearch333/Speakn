//
//  Dropbox_File_Browser.swift
//  Speakn
//
//  Created by Sergio Rosendo on 3/1/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation
import SwiftyDropbox

class Dropbox_File_Browser {
    var dropbox_client: DropboxClient!
    var directory: [Dropbox_Object]
    var next_available_id: UInt32
    
    init() {
        self.dropbox_client = nil
        self.directory = []
        self.next_available_id = 0
    }
    
    convenience init(dropbox_client: DropboxClient) {
        self.init()
        self.dropbox_client = dropbox_client
        
        //Setup the file browser by passing the root folder which is the top most node of the directory tree
        self.setup_file_browser(id: get_next_available_id(), path: "",
                                type: Dropbox_Object.Object_Type.Folder, parent_id: nil)
    }
    
    // FIXME: Clean up & explain what is happening
    private func setup_file_browser(id: UInt32, path: String, type: Dropbox_Object.Object_Type, parent_id: UInt32?){
        let new_object = Dropbox_Object(id: id, path: path, type: type, parent_id: parent_id)
        
        // Detemining if new object has children
        dropbox_client.files.listFolder(path: new_object.path).response
        { (result, error) in
            
            guard let children = result?.entries else {
                return
            }
            
            for child in children {
                let child_id = self.get_next_available_id()
                var child_type = Dropbox_Object.Object_Type.Unknown
                
                new_object.children_ids.append(child_id)
                
                if child.name.contains("."){
                    if child.name.contains(".csv"){
                       child_type = Dropbox_Object.Object_Type.CSV_File
                    } else {
                        child_type = Dropbox_Object.Object_Type.Unknown
                    }
                    
                } else {
                    child_type = Dropbox_Object.Object_Type.Folder
                }
                
                self.setup_file_browser(id: child_id, path: child.pathLower!, type: child_type, parent_id: new_object.id)
            }
        }
        self.directory.append(new_object)
    }
    
    /// Function obtains and updates next available Dropbox object id
    private func get_next_available_id() -> UInt32{
        let available_id = next_available_id
        next_available_id += 1
        
        return available_id
    }
}
