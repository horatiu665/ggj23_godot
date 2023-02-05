extends Line2D

class_name Path

@export var minWidth:float = 60
@export var maxWidth:float = 150
@export var growthRate:float = 4



var startJoint:Joint
var endJoint:Joint



# Called when the node enters the scene tree for the first time.
func _ready():
	
	width = minWidth

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
#	var length = get_legth()
#
#	width = clamp(maxWidth*length*0.00002,minWidth,maxWidth)
#
	pass

func increase_width(delta:float):

	
	width = clamp(width + delta*growthRate,minWidth,maxWidth)
	
	print("name:",name," w:", width)
	
	if startJoint != null:
		if startJoint.parentPath != null:
			startJoint.parentPath.increase_width(delta)
	pass

func get_legth() -> float:


	var accumulator:float = 0
	var prevPos = points[0]
	for i in range(1,points.size()):
		var pos:Vector2 = points[i]
		var seqVec:Vector2 = pos - prevPos
		var seqDist:float = seqVec.length()
		accumulator += seqDist

	return accumulator
