@tool
extends "_property_base_class.gd"


func _init(object : Node, property : Dictionary):
	var string = LineEdit.new()
	super(object, property, string, "text", "text_changed")
