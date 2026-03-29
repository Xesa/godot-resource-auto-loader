# ResourceAutoLoader
This is a small plugin that exposes child properties onto the owner node by setting up resources.

### Use case
Let's say you have an `Enemy` class that may include several nodes such as `EnemyHealthComponent` or `EnemyAttackComponent`. You'd like to expose those components' properties in the owner node so you can tweak those values for each instance, but here are your current options:
- Create proxy variables in the owner node that will be passed onto the children by writing specific code for each one of those variables.
- Create a resource system that, again, will need specific code for each child.
- Set the children as editable in the inspector and search through all of them to change their values.

#### But what if you could actually expose children properties without having to code anything?
That's what this plugin is for! With minimal implementation, you choose which properties expose and edit them in the owner node, as if it was just another property from that node.

# How to use it
For clarity sake, let's say you have the following structure:
```gdscript
Enemy # This is the owner node, where we want to be able to edit children properties
└ HealthComponent # This is the child node that we'll be focusing on for the example
└ AttackComponent
└ ...
```

### 1. Declare the properties you want to expose from the child node
- Use the `@export` annotation to make the properties visible for the plugin.
- You can use `@export_range` for floats and integers.
```gdscript
class_name EnemyHealthComponent extends Node

  @export_range(1,1000,1) var max_health : int
```

### 2. Define the exportable resource
- Declare a variable named `resource_type` with the `@export` annotation.
- Define the type and the value as `:= ExportableResource`.
```gdscript
class_name EnemyHealthComponent extends Node

  @export_range(1,1000,1) var max_health : int

  @export var resource_type := ExportableResource
```

### 3. Create a subclass that extends Resource
- This class must include the same properties that you want to export from the main class.
- Note that the names must be exactly the same between the node and the resource.
- You can also export properties that are already present in the base class, such as `position` for a `Node2D`, for example.
```gdscript
class_name EnemyHealthComponent extends Node

  @export_range(1,1000,1) var max_health : int

  @export var resource_type := ExportableResource
  class_name ExportableResource extends Resource
      @export_range(1,1000,1) var max_health : int
```

### 4. Modify the child properties from the owner node
- Now you can see the exported properties in the owner node and modify them without having to search each individual node in the scene tree.

# FAQ
#### The `resource_type` variable appears in the inspector as an empty node.
Yes, that's normal. You should leave it as is.
#### Can I name the `resource_type` variable differently?
Yes, in the plugin configuration (`plugin.cfg`) you can modify a variable named `resource_type_name` to whatever that fits your needs.
#### Can I name the `ExportableResource` subclass differently?
Yes, just make sure that you also change the reference in the `resource_type` variable. For example, if you name the subclass as `EnemyHealthResource` you should refer to it as:
```gdscript
@export var resource_type := EnemyHealthResource
```
#### Is it necessary that the `ExportableResource` class is a subclass of the class that we want to expose?
No, you can define the exportable resource as a class in any other script. Just make sure to refer to it correctly.
#### What are the supported types of properties?
So far you can work with _booleans_, _integers_, _floats_, _strings_, _Vector2_, _Vector3_, resource paths and node paths. I've been trying to allow other complex types but it seems that there's not an easy way to replicate Godot's UI for that kind of behaviour.
#### What are the supported hints?
For now, only `@export_range` is supported. There aren't many other useful hints for the type of properties currently supported. If I see there's something else that could be interesting I will add it.
#### Will you expand the plugin or add more supported types
Maybe, if I find a real need for any of my projects I will surely do it and upload the changes to this repository.
