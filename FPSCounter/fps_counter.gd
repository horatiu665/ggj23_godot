extends Node2D

@export var label:Label


var samples: Array[float]
var nextSampleIndex: int = 0

func _enter_tree():
	samples.resize(100)
	
	for i in range(0,samples.size()):
		samples[i] = 0.0
		
		
	queue_redraw()
		
		
		
	pass
	
func _process(delta):
	
	samples[nextSampleIndex%samples.size()] = delta
	nextSampleIndex+= 1
	
	var fps = Engine.get_frames_per_second()
		
	label.text = str(fps)
	
	queue_redraw()
	
	pass

func _draw():
	
	var startPos = Vector2.ZERO
	var heightScale = 4000
	
	for i in range(0,samples.size()):
		
		var sampleIndex = (i + nextSampleIndex)%samples.size()
		startPos.x = i*1.0
		
		
		draw_line(startPos,startPos - Vector2(0,samples[sampleIndex]*heightScale),Color.GREEN,1)
	
	

	pass
	
