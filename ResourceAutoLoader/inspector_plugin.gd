@tool
extends EditorInspectorPlugin

var object : Node

func _can_handle(object) -> bool:
	
	if object is not Node or object is EditorProperty:
		return false

	var resources = object.get("resources")
	if resources == null or resources is not Array:
		return clear_object()
		
	for element in resources:
		if element != null and element is not Resource:
			return clear_object()
				
	return set_object(object)


## Sets a new object reference and connects all the signals.
## Calls the `clear_object()` method before, so if there was another object referenced, saves all the values and stops referencing it.
func set_object(object : Node) -> bool:
	clear_object()

	self.object = object
	object.editor_state_changed.connect(apply_changes)
	object.property_list_changed
	
	return true
	

## Clears the object that is currently being referenced and all the signal connections.
## Calls the `apply_changes()` method before, so the resource values will be applied every time the inspector leaves the node.
func clear_object() -> bool:
	if self.object != null:
		apply_changes()
		if self.object.editor_state_changed.is_connected(apply_changes):
			self.object.editor_state_changed.disconnect(apply_changes)
			
	self.object = null
	return false


## Applies the changes made in the resources to every child node
func apply_changes() -> void:
	for child : Node in object.get_children():
		var resource_type : Object = child.get("resource_type")
		if resource_type is Resource:
			ResourceAutoLoader.load(child, resource_type)
