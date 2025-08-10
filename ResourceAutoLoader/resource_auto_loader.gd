@tool
class_name ResourceAutoLoader extends EditorPlugin
## Allows loading resources dynamically. Use the [code]load(Node, Object)[/code] method.


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
	var resource_properties = resource.get_property_list()
	var object_properties = _get_property_names(object.get_property_list())
	
	for prop in resource_properties:
		
		# If the resource property is exported and the object has the same property, sets the object property with the value of the resource
		if prop.usage == 4102:
			var name = prop.name
			if object_properties.has(name):
				object.set(name, resource.get(name))
				print(prop.name)


## Private method for extracting only the names of the properties after using the [code]Object.get_property_list()[/code] method.
static func _get_property_names(property_list : Array) -> Array:
	
	var property_names := []
	
	for prop in property_list:
		property_names.append(prop.name)
		
	return property_names
