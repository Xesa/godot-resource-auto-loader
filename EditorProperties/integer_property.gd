class_name ResourceAutoLoaderInteger extends ResourceAutoLoaderBaseProperty


func _init(object : Node, property : Dictionary):
	
	var min_value = get_hint_or_null(property.hint_string, 0)
	var max_value = get_hint_or_null(property.hint_string, 1)
	var step = get_hint_or_null(property.hint_string, 2)
	
	var spinbox = SpinBox.new()
	spinbox.min_value = min_value if min_value != null else -9999999
	spinbox.max_value = max_value if max_value != null else 9999999
	spinbox.step = step if step != null else 0.01
	
	super(object, property, spinbox, "value", "value_changed")
