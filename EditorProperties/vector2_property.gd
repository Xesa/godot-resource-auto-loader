class_name ResourceAutoLoaderVector2 extends ResourceAutoLoaderBaseProperty


func _init(object : Node, property : Dictionary):
	var vector = ResourceAutoLoaderVector2Control.new()
	super(object, property, vector, "vector", "value_changed")


class ResourceAutoLoaderVector2Control extends EditorProperty:
	
	signal value_changed(new_value : Vector2)
	
	var spin_x : SpinBox
	var spin_y : SpinBox
	var internal_change := false
	var vector : Vector2:
		set(value): set_vector(value)
	
	
	func _init():
		
		# Create spinboxes
		spin_x = SpinBox.new()
		spin_y = SpinBox.new()
		
		spin_x.min_value = -999999
		spin_x.max_value = 999999
		spin_x.step = 0.1
		
		spin_y.min_value = -999999
		spin_y.max_value = 999999
		spin_y.step = 0.1
		
		# Give a value to vector if it's null
		if vector == null:
			internal_change = true
			vector = Vector2(spin_x.value, spin_y.value)
			internal_change = false
		
		# Connect signals
		spin_x.value_changed.connect(_on_spin_changed)
		spin_y.value_changed.connect(_on_spin_changed)
		
		# Create outer layout
		var vbox = VBoxContainer.new()
		
		var prop_label = Label.new()
		prop_label.text = get_edited_property().capitalize()
		
		vbox.add_child(prop_label)
		add_child(vbox)
		
		# Create spinboxes layout
		var hbox = HBoxContainer.new()
		
		var label_x = Label.new()
		label_x.text = "x"
		label_x.add_theme_color_override("font_color", Color.INDIAN_RED)
		var label_y = Label.new()
		label_y.text = "y"
		label_y.add_theme_color_override("font_color", Color.SEA_GREEN)
		
		hbox.add_child(label_x)
		hbox.add_child(spin_x)
		hbox.add_child(label_y)
		hbox.add_child(spin_y)
		add_child(hbox)
		
		
	func _on_spin_changed(value):
		internal_change = true
		vector = Vector2(spin_x.value, spin_y.value)
		internal_change = false
		value_changed.emit(vector)
		emit_changed(get_edited_property(), vector)
		
		
	func set_vector(value):
		# Update the value of the spinboxes to match the real value of vector
		# This will only happen if it's an external change to avoid redundance
		if !internal_change:
			spin_x.value = value.x
			spin_y.value = value.y
		vector = value
		
		
