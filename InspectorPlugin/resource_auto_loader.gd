@tool
class_name ResourceAutoLoader extends EditorPlugin
## Allows loading resources dynamically. Use the [code]load(Node, Object)[/code] method.

static var RESOURCE_TYPE_NAME := "resource_type"
static var DEBUG := false

var inspector_plugin

func _enter_tree():
	var err = check_config_file()
	
	if err == OK:
		inspector_plugin = preload("inspector_plugin.gd").new()
		add_inspector_plugin(inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(inspector_plugin)


## Checks and loads the plugin configuration file.
func check_config_file() -> int:
	var config := ConfigFile.new()
	var err := config.load("res://addons/ResourceAutoLoader/plugin.cfg")

	if err == OK:
		RESOURCE_TYPE_NAME = config.get_value("plugin", "resource_type_name")
		DEBUG = config.get_value("plugin", "debug")
	else:
		printerr("Resource Auto Loader: Error loading .cfg file. Please, reinstall the plugin")

	return err
