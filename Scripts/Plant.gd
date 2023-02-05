extends Node2D

class_name Plant

@export var sprite0:Sprite2D
@export var sprite1:Sprite2D
@export var sprite2:Sprite2D
@export var sprite3:Sprite2D
@export var chilli:Sprite2D
@export var audio:Array[AudioStream]
@export var audioPlayer:AudioStreamPlayer2D
@export var shakeDur:float = 3

var animPlayer = $AnimationPlayer

var level:int = 0
var currentSprite:Sprite2D
var sprites:Array[Sprite2D]

var shakeTime:float = -1



# Called when the node enters the scene tree for the first time.
func _ready():
	
	sprite0.visible = false
	sprite1.visible = false
	sprite2.visible = false
	sprite3.visible = false
	chilli.visible = false

	sprites.append(sprite0)
	sprites.append(sprite1)
	sprites.append(sprite2)
	sprites.append(sprite3)

	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if shakeTime != -1:
		shakeTime += delta
		rotation = 0.1*sin(shakeTime*shakeTime*10)
	
		if shakeTime > shakeDur:
			next_level_internal()
			shakeTime = -1
	
	pass
	
func is_upgrading() -> bool:
	return shakeTime != -1
	
func shake_fraction() -> float:
	if shakeTime == -1:
		return 0
	return shakeTime/shakeDur	
	
func next_level():
	
	if level == 3:
		return
		
	if shakeTime != -1:
		return
		
	audioPlayer.stream = audio[level-1]
	audioPlayer.play()
		
	shakeTime = 0
		
		
func next_level_internal():
		

	
	if animPlayer:
		animPlayer.play("shake")
	

		
	level += 1
	
	if level > sprites.size():
		chilli.visible = true
		return
	
	if currentSprite:
		currentSprite.visible = false
		
	currentSprite = sprites[level - 1]
	currentSprite.visible = true
	
	pass

