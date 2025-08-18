class_name ResourceAutoLoaderResource extends ResourceAutoLoaderBaseProperty


func _init(object : Node, property : Dictionary):
	var resource = EditorResourcePicker.new()
	super(object, property, resource, "edited_resource", "resource_changed")
