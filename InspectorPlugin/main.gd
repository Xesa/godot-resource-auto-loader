@tool
class_name ExposeThemProperties extends EditorPlugin
## Allows loading resources dynamically. Use the [code]load(Node, Object)[/code] method.

const DEBUG := false
const IMPORTER_NODE_FLAG := "is_importer_node"
const EXPORTABLE_PROPERTY_HINT := "exportable_property"
const EXPORTABLE_NODEPATH_HINT := EXPORTABLE_PROPERTY_HINT + ":nodepath"

var inspector_plugin : EditorInspectorPlugin


func _enter_tree():
	inspector_plugin = preload("inspector_plugin.gd").new()
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(inspector_plugin)
