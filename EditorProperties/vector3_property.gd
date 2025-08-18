class_name ResourceAutoLoaderVector3 extends ResourceAutoLoaderBaseProperty


func _init(object : Node, property : Dictionary):
	var vector = Vector3Control.new()
	super(object, property, vector, "vector", "value_changed")


class Vector3Control extends EditorProperty:
	
	signal value_changed(new_value : Vector3)
	
	var spin_x : SpinBox
	var spin_y : SpinBox
	var spin_z : SpinBox
	
	var _vector : Vector3
	var vector : Vector3:
		set(value): set_vector(value)
		get: return _vector
		
	var internal_change := false
		
	
	func _init():
		
		# Create spinboxes
		spin_x = SpinBox.new()
		spin_y = SpinBox.new()
		spin_z = SpinBox.new()
		
		spin_x.min_value = -999999
		spin_x.max_value = 999999
		spin_x.step = 0.1
		
		spin_y.min_value = -999999
		spin_y.max_value = 999999
		spin_y.step = 0.1
		
		spin_z.min_value = -999999
		spin_z.max_value = 999999
		spin_z.step = 0.1
		
		# Give a value to vector if it's null
		if vector == null:
			internal_change = true
			vector = Vector3(spin_x.value, spin_y.value, spin_z.value)
		
		# Connect signals
		spin_x.value_changed.connect(_on_spin_changed)
		spin_y.value_changed.connect(_on_spin_changed)
		spin_z.value_changed.connect(_on_spin_changed)
		
		# Create outer layout
		var vbox = VBoxContainer.new()
		
		var prop_label = Label.new()
		prop_label.text = get_edited_property().capitalize()
		prop_label.custom_minimum_size = Vector2(60,0)
		
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
		var label_z = Label.new()
		label_z.text = "z"
		label_z.add_theme_color_override("font_color", Color.MEDIUM_PURPLE)
		
		hbox.add_child(label_x)
		hbox.add_child(spin_x)
		hbox.add_child(label_y)
		hbox.add_child(spin_y)
		hbox.add_child(label_z)
		hbox.add_child(spin_z)
		add_child(hbox)
		
		
	func _on_spin_changed(value):
		internal_change = true
		vector = Vector3(spin_x.value, spin_y.value, spin_z.value)
		value_changed.emit(vector)
		emit_changed(get_edited_property(), vector)
		
		
	func set_vector(value):
		# Update the value of the spinboxes to match the real value of vector
		# This will only happen if it's an external change to avoid redundance
		if !internal_change:
			spin_x.value = value.x
			spin_y.value = value.y
			spin_z.value = value.z
			internal_change = false
		_vector = value
		
		
