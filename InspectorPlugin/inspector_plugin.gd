@tool
extends EditorInspectorPlugin


func _can_handle(object: Object) -> bool:
	if object is not Node or object is EditorProperty:
		return false
	else:
		return true
	
			
func _parse_begin(object : Object) -> void:

	# Iterates every child and checks if any of them includes an exportable resource
	for child : Node in object.get_children():
		var resource_type : Object = child.get(ResourceAutoLoader.RESOURCE_TYPE_NAME)
		
		# Creates a group label for each child that includes an exportable resource
		if resource_type is Resource:
			ResourceAutoLoaderHelpers.create_group_label(self, child.name)

			var child_properties := ResourceAutoLoaderHelpers._get_object_properties(child)
			var resource_properties := ResourceAutoLoaderHelpers._get_resource_type_properties(resource_type.new())

			# Iterates every property from the exportable resource and checks if the current object has them
			for name in resource_properties.keys():

				if ResourceAutoLoader.DEBUG:
					print("Property %s (%d / %d)" % [name, resource_properties[name].type, child_properties[name].type])

				if child_properties.has(name):
					var editor_property : EditorProperty
					
					# If it's a basic property, creates a custom PropertyEditor for that property
					if resource_properties[name].type == child_properties[name].type:
						match resource_properties[name].type:
							1: editor_property = ResourceAutoLoaderCheckbox.new(child, resource_properties[name])
							2: editor_property = ResourceAutoLoaderNumber.new(child, resource_properties[name])
							3: editor_property = ResourceAutoLoaderNumber.new(child, resource_properties[name])
							4: editor_property = ResourceAutoLoaderString.new(child, resource_properties[name])
							5: editor_property = ResourceAutoLoaderVector2.new(child, resource_properties[name])
							9: editor_property = ResourceAutoLoaderVector3.new(child, resource_properties[name])
							24: editor_property = ResourceAutoLoaderResource.new(child, resource_properties[name])
							_: continue

					# If it's a NodePath, creates a custom PropertyEditor for managing node paths
					elif resource_properties[name].type == 22 and child_properties[name].type == 24:
						editor_property = ResourceAutoLoaderNodepath.new(child, resource_properties[name])
					
					# Finally, adds the PropertyEditor to the UI
					if editor_property:
						add_property_editor(name, editor_property, true, name.capitalize())
						
