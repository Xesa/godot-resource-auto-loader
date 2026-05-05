@tool
extends "_property_base_class.gd"


func _init(object : Node, property : Dictionary):
	var checkbox = CheckBox.new()
	checkbox.toggle_mode = true
	super(object, property, checkbox, "button_pressed", "pressed")
