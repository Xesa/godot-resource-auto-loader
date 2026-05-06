# Expose Them Properties!
This is a small plugin that exposes child properties onto parent nodes by setting up property hints.

### Use case
Let's say you have an `Character` class that may include several nodes such as `HealthComponent` or `AttackComponent`. You'd like to expose those components' properties onto the owner node so you can tweak those values for each instance. The _Expose Them Properties!_ plugin allows you to do that without compromising your code.

# How to use it
For clarity sake, let's say you have the following structure:
```gdscript
Character # This is the owner node, where we want to be able to edit children properties
└ HealthComponent # This is the child node that we'll be focusing on for the example
└ AttackComponent
└ ...
```

## 1. Expose the properties in the child node
#### Basic properties
- Use the `@export_custom` decorator.
- Use the `PROPERTY_HINT_FLAGS` constant for the `hint` value.
- Use the `ExposeThemProperties.EXPORTABLE_PROPERTY_HINT` for the `hint_string` value.
```gdscript
class_name HealthComponent extends Node

  @export_custom(PROPERTY_HINT_FLAGS, ExposeThemProperties.EXPORTABLE_PROPERTY_HINT) var is_dead := false
```
#### Ranges and other property types
- Use the `@export_range` or any other decorator you want to use.
- In this case you don't need to specify the `hint` value, just the `hint_string` value.
- Make sure the `hint_string` value is placed at the end.
```gdscript
class_name HealthComponent extends Node

  @export_range(0,10,1, ExposeThemProperties.EXPORTABLE_PROPERTY_HINT) var life := 10
```
#### Nodepaths
- Use the `@export_custom` decorator.
- Use the `PROPERTY_HINT_FLAGS` constant for the `hint` value.
- In this case you must use the `ExposeThemProperties.EXPORTABLE_NODEPATH_HINT` for the `hint_string` value.
```gdscript
class_name HealthComponent extends Node

  @export_custom(PROPERTY_HINT_FLAGS, ExposeThemProperties.EXPORTABLE_NODEPATH_HINT) var some_node : Node
```

## 2. Flag the owner node as an importer
You can flag the importer nodes in two different ways:
- By creating a constant in that node's script called `is_importer_node`.
- By adding a metadata key called `is_importer_node` in that node from the editor.

In both cases, it is recommeded that the variable/key is a boolean set to `true`.
```gdscript
class_name Character extends Node

  const is_importer_node := true
```
# FAQ
#### Will this work if the node that has the properties is not a direct child of the node that exposes them?
Yes, no matter how deep in the tree is the node, the nodes marked as importers will expose the properties of their children, grand-children and so on.
#### Can I name the `is_importer_node` variable/key differently?
Yes, in the plugin configuration (`plugin.cfg`) you can modify a variable named `importer_node_flag` to whatever that fits your needs.
#### What are the supported types of properties?
So far you can work with _booleans_, _integers_, _floats_, _strings_, _Vector2_, _Vector3_, resource paths and node paths. I've been trying to allow other complex types but it seems that there's not an easy way to replicate Godot's UI for that kind of behaviour.
#### What are the supported decorators besides `@export_custom`?
For now, only `@export_range` is supported. There aren't many other useful hints for the type of properties currently supported. If I see there's something else that could be interesting I will add it.
#### I've set up a NodePath but in the owner node I can only apply a script, not a node from the scene:
Make sure you're using the `EXPORTABLE_NODEPATH_HINT` constant.
#### Will you expand the plugin or add more supported types
Maybe, if I find a real need for any of my projects I will surely do it and upload the changes to this repository.
