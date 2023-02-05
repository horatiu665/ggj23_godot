extends Node2D

class_name Seed

@export var inputPath:Line2D
@export var growSpeed:float = 100
@export var growSectionmaxLength:float = 20
@export var jointDist:float = 400
@export var jointDropFraction:float = 1.5
@export var startwater:float = 1000
@export var startJoint:Node2D
@export var waterLabel:RichTextLabel
@export var pickupsNode:Node


var pathScene = load("res://Scenes/Path.tscn")
var jointScene = load("res://Scenes/Joint.tscn")


var mouseDown:bool

var drawingPath:bool

var mousePos:Vector2

var growingRoot:Line2D
var growingRootLenght:float
var growingSectionLength:float
var jointDistAccumulator:float

var joints:Array[Joint]

var water:float = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	#inputPath = get_node("InputPath") as Line2D
	inputPath.clear_points()
	inputPath.default_color = Color(1,1,1,0.1)

	joints.append(startJoint as Joint)
	
	water = startwater
	

func _on_reset_button_button_up():
	get_tree().reload_current_scene()
	


func _on_water_cheat_button_up():
	water += 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	
	var mouseBtn = Input.is_action_pressed("mouse_down");
	
	if mouseBtn && !drawingPath && water > 0:
		
		# Find joint closts to mouse pos that is inside raidus (if any)
		var joint:Joint
		var startPoint:Vector2
		var startPointFound:bool
		var minDist:float = 9999
		for j in joints:
			
			var dist = j.position.distance_to(mousePos)
			if dist < 50 && dist < minDist:
				minDist = dist
				startPointFound = true
				startPoint = j.position
				joint = j
			
			
			for path in j.paths:
				for p in path.points:
					
					dist = p.distance_to(mousePos)
					if dist < 50 && dist < minDist:
						minDist = dist
						startPointFound = true
						startPoint = p
						
			
		
		if startPointFound:
			
			
			
			# if not joint found craate one
			if joint != startJoint:
				joint = jointScene.instantiate()
				add_child(joint)
				joint.position = startPoint
				joint.radius = 200
				joints.append(joint)
			
			print("Starting growth from:",joint)
			
			drawingPath = true
			inputPath.clear_points()
			
			inputPath.default_color = Color(1,1,1,1)
			inputPath.add_point(startPoint)
			
			growingRoot = create_path(joint)
			growingRoot.add_point(startPoint) # two point so there is one for end
	
			growingRootLenght = 0
			growingSectionLength = 0
			jointDistAccumulator = 0
		
			
			
	if !mouseBtn && drawingPath:
		drawingPath = false
		
	if !drawingPath:
		var alpha = inputPath.default_color.a
		alpha = lerp(alpha,0.2,delta*1)
		inputPath.default_color = Color(1,1,1,alpha)
	
	
	# Input path is only valid after a certain length
	var inputPathValid = inputPath.points.size() > 1 && \
		+ inputPath.points[0].distance_to(inputPath.points[inputPath.points.size()-1]) > 100
	
	#print("inputPathValid:",inputPathValid, " drawing:", drawingPath, " growing:", growingRoot != null)
	
	if growingRoot != null && inputPathValid:
		update_growing(delta)
	
	
	for joint in joints:
		for path in joint.paths:
			if path.endJoint != null:
				continue
				
			# found end path
			
			var endPoint = path.points[path.points.size()-1]
						
			for child in pickupsNode.get_children():
				
				var pickup = child as Pickup
				if pickup.isAbsorbing:
					continue
				
				var dist = endPoint.distance_to(pickup.position)
				if dist < pickup.pickupDist:
					pickup.absorb(self,endPoint)
					
		

	waterLabel.text = str(water as int)
	
	
func update_growing(delta:float):
	var deltaLength = growSpeed*delta
	
	# cant grow without water
	water -= deltaLength
	if water < 0:
		water = 0
		return
	
	growingRootLenght += deltaLength
	
	
	var result = find_last_index_before_distance(inputPath.points,growingRootLenght)
#
	# Test from reaching end of input
	if result.index == inputPath.points.size() -1:
		growingRoot = null
		print("REACED END!!!!!!")
		return

	var pos = inputPath.points[result.index]
	var nextPos = inputPath.points[result.index + 1]
	
	var distLeft = growingRootLenght - result.lineLength
	var v = nextPos - pos
	

	# Test for collision
	var rayParam = PhysicsRayQueryParameters2D.create(pos,nextPos,1)
	var rayResult = get_world_2d().direct_space_state.intersect_ray(rayParam)
	if rayResult.size() > 0:
		growingRoot = null
		print("Collision!!!")
		return


	var newPoint = pos + v.normalized()*distLeft
	
#	# Should we create new joint?
#	jointDistAccumulator += deltaLength
#
#	if jointDistAccumulator > jointDist*jointDropFraction:
#
#		var cutResult = find_last_index_before_distance(growingRoot.points,jointDist)
#
#		# Create new joint
#		var joint = jointScene.instantiate()
#		add_child(joint)
#		joint.position = growingRoot.points[cutResult.index]
#		joint.radius = 200
#		joints.append(joint)
#
#
#		growingRoot.endJoint = joint
#
#
#		# Create new growing
#		var newPath = create_path(joint)
#
#
#		for i in range(cutResult.index+1,growingRoot.points.size()):
#			newPath.add_point(growingRoot.points[i])
#
#		growingRoot.points.resize(cutResult.index+1)
#
#		growingRoot = newPath
#
#		#growingRootLenght = 0
#		growingSectionLength = 0
#		jointDistAccumulator = jointDistAccumulator - jointDist


	# Detect next segment
	growingSectionLength += deltaLength
	if growingSectionLength > growSectionmaxLength:
		growingSectionLength -= growSectionmaxLength

	#	print("new point at length",growingRootLenght, " pos:", newPoint)
		growingRoot.add_point(newPoint)
	else:
		growingRoot.set_point_position(growingRoot.points.size()-1, newPoint)


func create_path(joint:Joint) -> Path:
	var path = pathScene.instantiate() as Path
		
	add_child(path)
	path.startJoint = joint
	# path.width = 20
	
	path.clear_points()
	path.add_point(joint.position)
	
	joint.paths.append(path)
	
	return path

class LineQuery:
	var index:int
	var lineLength:float

# resturns index and lengt
func find_last_index_before_distance(points:Array,dist:float) -> LineQuery:

	var result = LineQuery.new()

	var accumulator:float = 0
	var prevPos = points[0]
	for i in range(1,points.size()):
		var pos:Vector2 = points[i]
		var seqVec:Vector2 = pos - prevPos
		var seqDist:float = seqVec.length()
		accumulator += seqDist

		if accumulator > dist:
			
			result.index = i - 1
			result.lineLength = accumulator - seqDist
	
			return result
			
		prevPos = pos
	
	#return points.size()-1
	result.index = points.size()-1
	result.lineLength = accumulator
	return result

#func find_point_at_distance(points:Array, dist:float): 
#
#	var result = find_last_index_before_distance(points,dist)
##
#	var pos = points[result.index]
#	if result.index == points.size() -1:
#		return pos
#
#	var nextPos = points[result.index + 1]
#
#	var distLeft = dist - result.lineLength
#	var v = nextPos - pos
#	return pos + v.normalized()*distLeft

func _input(event):
   # Mouse in viewport coordinates.
		
		
	if event is InputEventMouseMotion:
		mousePos = event.position
		
		if drawingPath:
			inputPath.add_point(mousePos)
	#	print("Mouse Motion at: ", event.position)


	
   # Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport_rect().size)




