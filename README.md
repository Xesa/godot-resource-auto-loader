# How to use it
For clarity sake, let's say you have the following structure:
```gdscript
Enemy # This is the owner node, where we want to be able to edit children properties
└ HealthComponent # This is the child node that we'll be focusing on for the example
└ AttackComponent
```
### 1. Create a Resource
- Use the `@export` annotation to make the properties visible for the plugin.
- You can use `@export_range` for floats and integers.
- You can create nested classes for keeping things organized.

```gdscript
class_name EnemyResource extends Resource

  class EnemyHealthResource extends EnemyResource:
    @export_range(1,1000,1) var max_health : int
```

### 2. Declare the properties and the resource type in the child node
- Declare a variable named `resource_type` in the child node that holds a reference to the Resource you just created.
- Declare the different properties you want to import from the resource. Note that the names must be exactly the same.
- You can also import properties that are already present in the base class, such as `position` for a `Node2D`, for example.

```gdscript
class_name EnemyHealthComponent extends Node

  @export_range(1,1000,1) var max_health : int

  var resource_type := EnemyResource.EnemyHealthResource
```

### 3. Modify the child properties from the owner node
- Now you can see the exported properties in the owner node and modify them without having to search each individual node in the scene tree.

# FAQ
#### Can I name the `resource_type` variable differently?
Yes, in the plugin files you can edit `resource_auto_loader.gd` and change the value of the constant named `RESOURCE_TYPE_NAME`.
#### What are the supported types of properties
So far you can work with _booleans_, _integers_, _floats_, _strings_, _Vector2_, _Vector3_ and resource paths. I've been trying to allow node paths and other complex types but it seems that there's not an easy way to replicate Godot's UI for that kind of behaviour.
