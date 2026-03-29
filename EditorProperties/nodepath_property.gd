class_name ResourceAutoLoaderNodepath extends ResourceAutoLoaderBaseProperty


func _init(object : Node, property : Dictionary):
	var nodepath := NodePathControl.new(object, property)
	super(object, property, nodepath, "node", "node_changed")


func update_control_property() -> void:
	control.node = get_current_value()
	control.toggle_select_button(control.node != null)


class NodePathControl extends EditorProperty:

	var container : HBoxContainer 
	var select_button : Button
	var clean_button : Button
	var property_type : Array[StringName]

	var node : Node

	signal node_changed(new_node : Node)


	func _init(object : Node, property : Dictionary) -> void:

		# Sets the property type string
		var property_name = property["name"]
		var object_properties := ResourceAutoLoaderHelpers._get_object_properties(object)
		var object_property = object_properties[property_name]

		var hint_string = object_property.get("hint_string")

		if hint_string != null and hint_string != "":
			property_type = [hint_string]

		# Sets the UI
		container = HBoxContainer.new()
		container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		select_button = Button.new()
		select_button.text = "Select node"
		select_button.pressed.connect(_open_selector)
		select_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		select_button.clip_text = true
		select_button.custom_minimum_size.x = 100
		
		clean_button = Button.new()
		clean_button.text = "X"
		clean_button.disabled = true
		clean_button.pressed.connect(clean_node)
		
		container.add_child(select_button)
		container.add_child(clean_button)
		add_child(container)


	func _open_selector() -> void:
		EditorInterface.popup_node_selector(set_node, property_type)


	func set_node(nodepath) -> void:
		if nodepath == NodePath(""):
			return

		node = EditorInterface.get_edited_scene_root().get_node(nodepath)
		toggle_select_button(true)
		node_changed.emit(node)
		emit_changed(get_edited_property(), node)


	func clean_node() -> void:
		node = null
		toggle_select_button(false)
		node_changed.emit(node)
		emit_changed(get_edited_property(), node)

	
	func toggle_select_button(toggle : bool) -> void:
		if toggle:
			select_button.text = node.name
			select_button.add_theme_color_override("font-color", Color.LIGHT_BLUE)
			clean_button.disabled = false
		else:
			select_button.text = "Select node"
			select_button.remove_theme_color_override("font-color")
			clean_button.disabled = true
