@tool
class_name ResourceAutoLoader extends EditorPlugin
## Allows loading resources dynamically. Use the [code]load(Node, Object)[/code] method.

var inspector_plugin


func _enter_tree():
	inspector_plugin = preload("inspector_plugin.gd").new()
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(inspector_plugin)
	

## Searches for an Array variable named [code]resources[/code] in the owner node of [code]object[/code].
## Then it finds any resource that extends [code]resoure_type[/code] and loads any exported variables
## into any homonym variables from [code]object[/code].
static func load(object : Node, resource_type : Object) -> void:
	
	# Finds the resources property and iterates in search of any instance of resource_type
	var resources = object.owner.get("resources")
	var resource : Resource = null

	for res : Resource in resources:
		
		if is_instance_of(res, resource_type):
			resource = res
	
	if resource == null:
		return
		
	# Gets all the properties from the resource and the object
	var resource_properties = _get_resource_properties(resource)
	var object_properties = _get_object_properties(object)
	
	for prop in resource_properties:
		if object_properties.has(prop):
			object.set(prop, resource.get(prop))


## Private method for extracting only the names of the properties after using the [code]Object.get_property_list()[/code] method.
static func _get_object_properties(object : Node) -> Array:
	
	var property_names := []
	
	for p in object.get_property_list():
		property_names.append(p.name)
		
	return property_names
	
	
## Private method for extracting the properties from the Resource ignoring properties that shouldn't be replaced in the object
static func _get_resource_properties(resource : Resource) -> Array:
	
	# Adds any base property to a list
	var base_properties = [
		"RefCounted", "Resource", "resource_local_to_scene", "resource_path",
		"resource_name", "resource_scene_unique_id", "script", "metadata/_custom_type_script"
	]

	for p in ClassDB.class_get_property_list("Resource"):
		base_properties.append(p.name)
		
	for p in ClassDB.class_get_property_list("Script"):
		base_properties.append(p.name)
		
	for p in ClassDB.class_get_property_list("Node"):
		base_properties.append(p.name)
		
	for p in ClassDB.class_get_property_list("Object"):
		base_properties.append(p.name)


	# Adds the Resource properties that are not in the base properties
	var custom_properties = []
	for p in resource.get_property_list():
		if p.name not in base_properties:
			custom_properties.append(p.name)
			

	return custom_properties
	
