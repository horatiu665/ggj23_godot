extends Node2D

class_name Joint



@export var radius:float = 50

@onready var animation_player = $AnimationPlayer

var paths:Array[Path]

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("spawn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
