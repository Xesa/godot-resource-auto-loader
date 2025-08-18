@tool
class_name ResourceAutoLoader extends EditorPlugin
## Allows loading resources dynamically. Use the [code]load(Node, Object)[/code] method.

const RESOURCE_TYPE_NAME := "resource_type"

var inspector_plugin

func _enter_tree():
	inspector_plugin = preload("inspector_plugin.gd").new()
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(inspector_plugin)




	
