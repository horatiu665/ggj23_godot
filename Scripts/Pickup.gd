extends Node2D

class_name Pickup

@export var pickupDist:float = 100
@export var startWater:float
@export var absorbSpeed:float = 100
@export var spriteSizeFactor:float =0.01
@export var spriteRotSpeed:float = 1
@export var sprite:Node2D
@export var sizeCurve:Curve


var isAbsorbing:bool
var absorbPoint:Vector2
var startPoint:Vector2
var seed:Seed
var water:float
var rotSpeed:float


# Called when the node enters the scene tree for the first time.
func _ready():
	var x = randf_range(0, TAU)
	rotation = x
	water = startWater	
	startPoint = position
	update_sprite_scale()
	pass # Replace with function body.


func absorb(seed:Seed, point:Vector2):
	
	self.seed = seed
	isAbsorbing = true
	absorbPoint = point		
	
	var rng = RandomNumberGenerator.new()
	rotSpeed =  rng.randf_range(-spriteRotSpeed, spriteRotSpeed)
	
					
	pass

func update_sprite_scale():
	
	
	var waterFraction = water/startWater
	
	var mappedFraction = sizeCurve.sample(waterFraction)
	
	var scale = mappedFraction*startWater*spriteSizeFactor
	
	
	sprite.scale = Vector2(scale,scale)
	
	if isAbsorbing:
		position = absorbPoint -  (absorbPoint - startPoint)*mappedFraction
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if isAbsorbing:
		
		var amount = ceil(absorbSpeed*delta)
		if amount > water:
			amount = water
			
		water -= amount
		seed.water += amount
		
		update_sprite_scale()
		
		rotation += rotSpeed*delta
		#position = lerp(position,absorbPoint,delta*1)
		
		if water == 0:
			queue_free()
	pass
