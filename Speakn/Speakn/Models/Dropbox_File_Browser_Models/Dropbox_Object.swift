//
//  Dropbox_Object.swift
//  Speakn
//
//  Created by Sergio Rosendo on 3/1/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import Foundation
class Dropbox_Object {
    /// Type of objects in Dropbox file browser
    enum Object_Type {
        case CSV_File   // Objects with .csv extensions
        case Folder     // Objects with no extension but contain children objects
        case Unknown    // Objects with no extension bui do not have any children (Ex: Files with no extensions)
    }
    
    var id: Int
    var path: String
    var type: Object_Type
    var parent_id: Int?
    var children_ids: [Int]
    
    
    init(id: Int, path: String, type: Object_Type, parent_id: Int?) {
        self.id = id
        self.path = path
        self.type = type
        self.parent_id = parent_id
        self.children_ids = []
    }
}
