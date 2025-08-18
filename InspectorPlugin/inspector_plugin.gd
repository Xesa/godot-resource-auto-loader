@tool
extends EditorInspectorPlugin


func _can_handle(object: Object) -> bool:
	if object is not Node or object is EditorProperty:
		return false
	else:
		return true
	
			
func _parse_begin(object : Object) -> void:
	for child : Node in object.get_children():
		var resource_type : Object = child.get(ResourceAutoLoader.RESOURCE_TYPE_NAME)

		if resource_type is Resource:
			ResourceAutoLoaderHelpers.create_group_label(self, child.name)
			
			var resource_properties := ResourceAutoLoaderHelpers._get_resource_type_properties(resource_type.new())

			for name in resource_properties.keys():
				var child_properties := ResourceAutoLoaderHelpers._get_object_properties(child)
				print(resource_properties[name])
				
				if child_properties.has(name) and resource_properties[name].type == child_properties[name].type:
					var editor_property : EditorProperty
					
					# TODO AÑADIR SOPORTE PARA TEXTURAS Y OTROS RECURSOS
					

					match resource_properties[name].type:
						1: editor_property = ResourceAutoLoaderCheckbox.new(child, resource_properties[name])
						2: editor_property = ResourceAutoLoaderInteger.new(child, resource_properties[name])
						3: print("float")
						4: print("string")
						5: editor_property = ResourceAutoLoaderVector2.new(child, resource_properties[name])
						24: editor_property = ResourceAutoLoaderResource.new(child, resource_properties[name])
						_: continue
						
					if editor_property:
						add_property_editor(name, editor_property, true, name.capitalize())
						
