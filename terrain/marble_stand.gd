#@tool

extends Node3D

const holes = 7

@export var speed = PI/holes/10

var current_hole_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$MarbleStandGimmick.rotation.y += speed * delta


func get_current_hole_position() -> Vector3:
	
	var current_hole_marker = get_node_or_null("MarbleStandGimmick/HoleMarker%d" % (current_hole_index+1))
	
	if current_hole_marker == null:
		print("Marker is not found")
		return Vector3.ZERO
	
	current_hole_index += 1
	if current_hole_index == 7: 
		current_hole_index = 0
		
	return current_hole_marker.global_position
