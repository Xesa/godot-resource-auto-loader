@tool
class_name ResourceAutoLoaderString extends ResourceAutoLoaderBaseProperty


func _init(object : Node, property : Dictionary):
	var string = LineEdit.new()
	super(object, property, string, "text", "text_changed")
