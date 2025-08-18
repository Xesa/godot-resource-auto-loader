@tool
class_name ResourceAutoLoaderCheckbox extends ResourceAutoLoaderBaseProperty


func _init(object : Node, property : Dictionary):
	var checkbox = CheckBox.new()
	checkbox.toggle_mode = true
	super(object, property, checkbox, "button_pressed", "pressed")
