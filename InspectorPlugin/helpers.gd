@tool
class_name ResourceAutoLoaderHelpers extends EditorScript


## Helper method for extracting only the names of the properties after using the [code]Object.get_property_list()[/code] method.
static func _get_object_properties(object : Node) -> Dictionary:
	
	var properties := {}
	
	for p in object.get_property_list():
		properties[p.name] = p
		
	return properties
	
	
## Helper method for extracting the properties from the Resource ignoring properties that shouldn't be replaced in the object
static func _get_resource_type_properties(resource : Resource) -> Dictionary:
	
	# Adds any base property to a list
	var base_properties = [
		"RefCounted", "Resource", "resource_local_to_scene", "resource_path",
		"resource_name", "resource_scene_unique_id", "script", "metadata/_custom_type_script"
	]

	for p in ClassDB.class_get_property_list("Resource"):
		base_properties.append(p.name)
		
	for p in ClassDB.class_get_property_list("Script"):
		base_properties.append(p.name)


	# Adds the Resource properties that are not in the base properties
	var custom_properties := {}
	for p in resource.get_property_list():
		if p.usage & PROPERTY_USAGE_EDITOR == 0:
			continue
		if p.name.ends_with(".gd"):
			continue
		if p.name in base_properties:
			continue
		
		custom_properties[p.name] = p
			
	return custom_properties
	
	
static func create_group_label(editor : EditorInspectorPlugin, name : String) -> void:
	var label = Label.new()
	label.text = name
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color8(203, 204, 205))
	label.add_theme_font_size_override("font_size", 13)

	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color8(64, 68, 76)
	stylebox.corner_detail = 12
	
	label.add_theme_stylebox_override("normal", stylebox)
	editor.add_custom_control(label)

	
static func update_object_property(editor : EditorProperty, object : Object, value : Variant) -> void:
	var root = EditorInterface.get_edited_scene_root()
	if not root: return
	
	var parent = object.owner as Node
	root.set_editable_instance(parent, true)
	object.set(editor.get_edited_property(), value)
	
	editor.emit_changed(editor.get_edited_property(), value)
	
	

static func get_hint_or_null(hint : String, index : int) -> Variant:
	
	if hint.is_empty(): return null
		
	var parts = hint.split(",")
	if parts.is_empty(): return null
	
	var value = parts.get(index)
	return str_to_var(value)
		
	
