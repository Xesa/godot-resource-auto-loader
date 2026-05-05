@tool
extends EditorScript

const MAIN := preload("main.gd")


static func scan_children_nodes(node : Node, properties : Array[Dictionary] = []) -> Array[Dictionary]:

	var node_properties := get_exportable_properties(node)

	if node_properties["properties"].size() > 0:
		properties.append(node_properties)

	for child in node.get_children():
		scan_children_nodes(child, properties)

	return properties


static func get_exportable_properties(node : Node) -> Dictionary:

	var node_properties := {"node" : node, "node_name": node.name, "properties" : {}}

	for p in node.get_property_list():
		if p.has("hint_string") and p.hint_string.contains(MAIN.EXPORTABLE_PROPERTY_HINT):
			node_properties["properties"][p.name] = p

	return node_properties


static func get_object_property(object : Node, property_name : String) -> Dictionary:

	for p in object.get_property_list():
		if p.name == property_name:
			return p

	return {}


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
		
	
