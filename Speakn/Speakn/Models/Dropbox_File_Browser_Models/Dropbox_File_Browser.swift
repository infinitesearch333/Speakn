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
    var dispatch_group: DispatchGroup
    
    var directory: [Dropbox_Object]
    var next_available_id: Int
    
    init(dispatch_group: DispatchGroup) {
        self.dropbox_client = DropboxClientsManager.authorizedClient
        self.dispatch_group = dispatch_group
        
        self.directory = []
        self.next_available_id = 0
        
        //Setup the file browser by passing the root folder which is the top most node of the directory tree
        self.setup(id: get_next_available_id(), path: "", type: .Folder, parent_id: nil)
    }
    
    /**
    Function recursively traverses the user's online Dropbox directory
    and builds a local version in the structure of a tree
    */
    private func setup(id: Int, path: String, type: Dropbox_Object.Object_Type, parent_id: Int?){
        let new_object = Dropbox_Object(id: id, path: path, type: type, parent_id: parent_id)
        
        self.dispatch_group.enter()
        
        // Detemining if new object has children
        self.dropbox_client.files.listFolder(path: new_object.path).response
        { (result, error) in
            
            guard let children = result?.entries else {
                self.dispatch_group.leave()
                return
            }
            
            for child in children {
                // Assigning child a reference id
                let child_id = self.get_next_available_id()
                
                new_object.children_ids.append(child_id)
                
                // Determining child object type
                let child_type: Dropbox_Object.Object_Type
                
                if child.name.contains("."){
                    if child.name.contains(".csv"){
                       child_type = .CSV_File
                    } else {
                        child_type = .Unknown
                    }
                    
                } else {
                    child_type = .Folder
                }
                
                self.setup(id: child_id, path: child.pathLower!, type: child_type, parent_id: new_object.id)
            }
            
            self.dispatch_group.leave()
        }
        self.directory.append(new_object)
    }
    
    /// Function obtains and updates next available Dropbox object id
    private func get_next_available_id() -> Int{
        let available_id = next_available_id
        next_available_id += 1
        
        return available_id
    }
}
