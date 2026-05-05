@tool
class_name ExposeThemProperties extends EditorPlugin
## Allows loading resources dynamically. Use the [code]load(Node, Object)[/code] method.

static var DEBUG := false
static var IMPORTER_NODE_FLAG := "is_importer_node"

const EXPORTABLE_PROPERTY_HINT := "exportable_property"
const EXPORTABLE_NODEPATH_HINT := EXPORTABLE_PROPERTY_HINT + ":nodepath"

var inspector_plugin : EditorInspectorPlugin


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
	var err := config.load("res://addons/xesa/ExposeThemProperties/plugin.cfg")

	if err == OK:
		DEBUG = config.get_value("plugin", "debug")
		IMPORTER_NODE_FLAG = config.get_value("plugin", "importer_node_flag")

	else:
		printerr("Expose Them Properties: Error loading .cfg file (err: " + str(err)+ "). Please, reinstall the plugin.")

	return err
