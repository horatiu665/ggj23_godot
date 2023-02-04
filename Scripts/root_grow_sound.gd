extends AudioStreamPlayer2D

@export var volume:float = 0
@export var max_volume: float = 0.5

var target_volume:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# default zero
	target_volume = 0
	# growing root
	if get_node("../../Roots").get("growingRoot")!=null:
		target_volume = max_volume
	# no water
	if get_node("../../Roots").get("water")<=0:
		target_volume = 0
	
	# smooth lerp volume
	var lerp_factor = 0.1
	if target_volume > volume:
		lerp_factor = 0.01
	volume = lerp(volume, target_volume, lerp_factor)
	
	self.volume_db = linear_to_db(volume)
	pass
