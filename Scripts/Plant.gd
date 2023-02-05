extends Node

class_name Plant

@export var sprite0:Sprite2D
@export var sprite1:Sprite2D
@export var sprite2:Sprite2D

var animPlayer = $AnimationPlayer

var level:int = 0
var currentSprite:Sprite2D
var sprites:Array[Sprite2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	sprite0.visible = false
	sprite1.visible = false
	sprite2.visible = false

	sprites.append(sprite0)
	sprites.append(sprite1)
	sprites.append(sprite2)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func next_level():
	
	if level == 3:
		return
	
	if animPlayer:
		animPlayer.play("shake")
	
	if currentSprite:
		currentSprite.visible = false
		
	level += 1
	
	
	currentSprite = sprites[level - 1]
	currentSprite.visible = true
	
	pass

