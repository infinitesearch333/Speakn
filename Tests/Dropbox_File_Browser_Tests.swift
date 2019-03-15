// File Browser Test Script
for object in self.dropbox_file_browser.directory {
	print("Object ID: \(object.id)")
    print("Object Path: \(object.path)")
    print("Object Type: \(object.type)")
    print("Object Parent ID: \(object.parent_id)")
    print("Obhect Children IDs: \(object.children_ids)")
}