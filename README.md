
Small plugin that imports resources dynamically onto a node from its owner node. This is especially useful for composition patterns where you need to access the properties of a child node without enabling the 'Editable Children' option in the inspector.

# Use case
#### Common issue
Let's say you have an `Enemy` node, that may include several different child nodes like `EnemyStatsComponent`, `EnemyCombatComponent` or `EnemyFlightComponent`.
Each of these components has exported properties that you might want to fine-tune for each variant of the same enemy.
In a normal setting you would have to either:
1. Make the children editable in the inspector — Which can lead to some overhead and is prone to errors.
2. Declare proxy properties in the parent node that will be passed onto the child node — Which is not ideal in the case that you don't need every property available for every type of enemy (ie. non-flying enemies don't need to set up the `FlightComponent`).
3. Make a different scene for each enemy variant — Even if you only have to tweak a couple of numbers!
4. Or use resources and make a script for loading them.

#### What if you could autoload resources dynamically for each type of component without extra coding?
That's what this plugin is for!
With this plugin you can set a single variable for all the resources in the parent node, and each component can include a variable that holds the type of Resource they are expecting.
The plugin covers the following situations:

🛡 **Type safe**, so a node won't load the wrong resource type.

🔎 **Property checking**, so the plugin won't try to load a property onto a node that doesn't have it.

🔗 **Resource inheritance**, so you can set the parent node to only allow resources that extend a certain type.

🗂 **Multiple resource support**, so it doesn't matter if only one child node or many of them need to import resources, the parent node can hold as many resources of any type as needed.

✏ **Automatic editor updates**, so the changes will be visible immediately. Especially useful for textures and collision shapes.



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
- Declare the properties that you want to be modified by the Resource if they don't exist already in the base class.
- Declare a property named `resource_type` that holds the Resource class that the node expects.

```gdscript
class_name EnemyStatsComponent extends Node

var health : int
var speed : int

var resource_type := StatsResource
```

Additionally, you can call `ResourceAutoLoader.load(self, resource_type)` in the `_ready` method, where `resource_type` is the type of the resource that you want to allow.
```gdscript
func _ready() -> void:
	ResourceAutoLoader.load(self, resource_type)
```

#### Inside the owner node:
- Declare a property named `resources` of type `Array[Resource]`
- The allowed resources will be of any type that extends the type of the Array, so you can declare an Array with a more concrete type of Resource, like `EnemyResource`.

```gdscript
class_name Enemy extends CharacterBody2D

@export var resources : Array[EnemyResource]
```

#### In the inspector:
- Now you can create a Resource of the chosen type within the node properties and tweak the values, or import a Resource that you already have in the project.

<p align="center"><img src="https://github.com/Xesa/godot-resource-auto-loader/blob/main/images/Screenshot_01.JPG"></p>
<p align="center">Create or import a resource and tweak the values in the Owner node.</p>
<p align="center"><img src="https://github.com/Xesa/godot-resource-auto-loader/blob/main/images/Screenshot_02.JPG"></p>
<p align="center">Any changes that you apply will be replicated in the child node.</p>

# FAQ
#### ¿Can I change the name of the array and Resource type variables?
Yes, in the `resource_auto_loader.gd` file there are two constants named `RESOURCE_ARRAY_NAME` for the resources array in the Owner node and `RESOURCE_TYPE_NAME` for the Resource type in the child node. You can change those values to whatever name you want to use for the variable names.

#### ¿Can I modify this plugin?
Yes, but be careful, if you don't know what you're doing you could end up replacing properties that you don't want to. Even the scrip attatched to the nodes is replaceable.
