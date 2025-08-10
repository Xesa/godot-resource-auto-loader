
Small plugin that imports resources dynamically onto a node from its owner node. This is especially useful for composition patterns where you need to access the properties of a child node without enabling the 'Editable Children' option in the inspector.

# Use case
#### Common issue
Let's say you have an `Enemy` node, that may include several different child nodes like `EnemyStatsComponent` or `EnemyCombatComponent`.
Each of these components has exported properties that you might want to fine-tune for each variant of the same enemy.
In a normal setting you would have to either:
1. Make the children editable in the inspector.
2. Declare proxy properties in the parent node that will be passed onto the child node.
3. Make a different scene for each enemy variant even if only a couple of numbers will differ from one another.
4. Or use resources and make a script for loading them.

#### What if you could autoload resources dynamically for each type of component without extra coding?
That's what this plugin is for!
With this plugin you can set a single variable for all the resources in the parent node, and each component can call the plugin for auto-loading the resources they need whenever they need.
The plugin covers the following situations:

🛡 **Type safe**, so a node won't load the wrong resource type.

🔎 **Property checking**, so the plugin won't try to load a property onto a node that doesn't have it.

🔗 **Resource inheritance**, so you can set the parent node to only allow resources that extend a certain type.

🗂 **Multiple resource support**, so it doesn't matter if only one child node or many of them need to import resources, the parent node can hold as many resources as needed.



# How to use it
#### Create a new Resource type:
- To make a property detectable by the script, you must annotate them with `@export`.
- Property names must be the same as in the node that will import them.
- You can extend a type of Resource if you want to keep things organized.

```gdscript
class_name EnemyStatsResource extends EnemyResource

@export health : int
@export speed : int
```

#### Inside the node that needs to import the resource properties:
- Declare the properties that you want to be modified by the resource if they don't exist already in the base class.
- In the `_ready` method, call `ResourceAutoLoader.load(self, resource_type)`, where `resource_type` is the type of the resource that you want to allow.

```gdscript
class_name EnemyStatsComponent extends Node

var health : int
var speed : int

func _ready() -> void:
	ResourceAutoLoader.load(self, EnemyStatsResource)
```

#### Inside the owner node:
- Declare a property named `resources` of type `Array[Resource]`
- The allowed resources will be of any type that extends the type of the Array, so you can declare an Array with a more concrete type of Resource, like `EnemyResource`.

```gdscript
class_name Enemy extends CharacterBody2D

@export var resources : Array[EnemyResource]
```

