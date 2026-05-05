@tool
extends EditorInspectorPlugin

const MAIN := preload("main.gd")
const HELPERS := preload("helpers.gd")

const CHECKBOX_PROPERTY := preload("../EditorProperties/checkbox_property.gd")
const NODEPATH_PROPERTY := preload("../EditorProperties/nodepath_property.gd")
const NUMBER_PROPERTY := preload("../EditorProperties/number_property.gd")
const RESOURCE_PROPERTY := preload("../EditorProperties/resource_property.gd")
const STRING_PROPERTY := preload("../EditorProperties/string_property.gd")
const VECTOR2_PROPERTY := preload("../EditorProperties/vector2_property.gd")
const VECTOR3_PROPERTY := preload("../EditorProperties/vector3_property.gd")


func _can_handle(object: Object) -> bool:
	if object is not Node or object is EditorProperty:
		return false
	else:
		return true
	
			
func _parse_begin(object : Object) -> void:

	# Returns if the selected node is not an importer
	if HELPERS.get_object_property(object, MAIN.IMPORTER_NODE_FLAG).size() == 0:
		return

	# Iterates every child and finds their exportable properties
	var properties := HELPERS.scan_children_nodes(object)

	for node_info in properties:
		_add_property_editors(node_info)


func _add_property_editors(node_info : Dictionary) -> void:

	var node : Node = node_info["node"]
	var node_name : String = node_info["node_name"]
	var properties : Dictionary = node_info["properties"]

	if properties.size() == 0:
		return

	HELPERS.create_group_label(self, node.name)

	# Iterates every property from the exportable resource and checks if the current object has them
	for name in properties.keys():

		if MAIN.DEBUG:
			print("Property %s (%d)" % [name, properties[name].type])

		var editor_property : EditorProperty
		
		# If it's a basic property, creates a custom PropertyEditor for that property
		match properties[name].type:
			1: editor_property = CHECKBOX_PROPERTY.new(node, properties[name])
			2: editor_property = NUMBER_PROPERTY.new(node, properties[name])
			3: editor_property = NUMBER_PROPERTY.new(node, properties[name])
			4: editor_property = STRING_PROPERTY.new(node, properties[name])
			5: editor_property = VECTOR2_PROPERTY.new(node, properties[name])
			9: editor_property = VECTOR3_PROPERTY.new(node, properties[name])

			24: 
				if properties[name].hint_string == MAIN.EXPORTABLE_NODEPATH_HINT:
					editor_property = NODEPATH_PROPERTY.new(node, properties[name])
				else:
					editor_property = RESOURCE_PROPERTY.new(node, properties[name])

			_: continue
		
		# Finally, adds the PropertyEditor to the UI
		if editor_property:
			add_property_editor(name, editor_property, true, name.capitalize())
