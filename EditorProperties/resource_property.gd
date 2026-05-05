extends "_property_base_class.gd"


func _init(object : Node, property : Dictionary):
	var resource = EditorResourcePicker.new()
	super(object, property, resource, "edited_resource", "resource_changed")
