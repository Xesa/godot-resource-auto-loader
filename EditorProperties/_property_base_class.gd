@tool
class_name ResourceAutoLoaderBaseProperty extends EditorProperty

var object : Node
var control : Control
var value_path : String


func _init(_object : Object, _property : Dictionary, _control : Control, _value_path : String, _signal_path : String, _signal_method := "_on_edited") -> void:
	
	# Set base variables
	self.name = _property.name.capitalize()
	self.value_path = _value_path
	self.object = _object
	
	# Set editor properties
	set_object_and_property(object, _property.name)
	set_custom_minimum_size(Vector2(0, 24))
	
	# Set control properties
	self.control = _control
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Connects the signal
	control.connect(_signal_path, Callable(self, _signal_method))
	add_child(control)
	update_control_property()


## Function to be called when the [code]control[/code] signal is emitted. Use this function if the signal has no arguments.
func _on_edited(arg1 : Variant = null, arg2 : Variant = null, arg3 : Variant = null, arg4 : Variant = null, arg5 : Variant = null) -> void:
	update_object_property()
		

## Updates the value of the control with the given property from [code]object[/code].
func update_control_property() -> void:
	control.set(value_path, get_current_value())
	
	
## Updates the value of the given property on [code]object[/code]. This function can be overwritten if needed.	
func update_object_property() -> void:
	
	var root := EditorInterface.get_edited_scene_root()
	if not root: return
	
	var parent = object.owner as Node

	if parent != root:
		root.set_editable_instance(parent, true)
	
	var value = control.get(value_path)
	object.set(get_edited_property(), value)
	
	self.emit_changed(get_edited_property(), value)


## Returns the current value of the given property from [code]object[/code].
func get_current_value() -> Variant:
	return get_edited_object().get(get_edited_property())
	

## Returns the from [code]property[/code] in the given index. If there is no hint at said index, returns [code]null[/code].
## Call this function to match the hints coming from the type of [code]@export[/code] annotation used in the resource properties
## such as [code]@export_range[/code].
func get_hint_or_null(hint : String, index : int) -> Variant:
	
	if hint.is_empty(): return null
		
	var parts = hint.split(",")
	if parts.is_empty(): return null
	
	var value = parts.get(index)
	return str_to_var(value)
