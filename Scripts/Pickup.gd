extends Node2D

class_name Pickup

@export var water:float

# Called when the node enters the scene tree for the first time.
func _ready():
	var x = randf_range(0, TAU)
	rotation = x
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
