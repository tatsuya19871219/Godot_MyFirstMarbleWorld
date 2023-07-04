@tool

extends Camera3D

@export var target_nodepath: NodePath

@export var tracking_distance: float = 5

# default tracking angles (rot x, rot z)
@export var theta = PI/4
@export var phi = PI/3

@export_range(0.0, 1.0, 0.01) var tracking_sync_ratio: float = 0.5

@export_category("Optional")
@export var center_nodepath: NodePath

var target: Node3D = null #= get_node(target_nodepath)
var center_object: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if not center_nodepath.is_empty():
		center_object = get_node(center_nodepath)
	
	if not target_nodepath.is_empty():
		target = get_node(target_nodepath)
	else:
		return
	
	# initialize position & rotation
	var camera_target_position = get_camera_target_position()
	var camera_initial_position = get_camera_new_position(camera_target_position)
	
	global_position = camera_initial_position
	
	look_at_from_position(global_position, camera_target_position)


func set_tracking_target(tracking_target: Node3D):
	target = tracking_target
	
	var camera_target_position = get_camera_target_position()
	var camera_initial_position = get_camera_new_position(camera_target_position)
	
	global_position = camera_initial_position
	
	look_at_from_position(global_position, camera_target_position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if target == null: return
	
	var target_position = get_camera_target_position()
	
	var camera_last_position = global_position
	var camera_new_position = get_camera_new_position(target_position)
	
	global_position = camera_last_position + tracking_sync_ratio * (camera_new_position - camera_last_position) * delta
	
	look_at_from_position(global_position, target_position)


func get_camera_target_position() -> Vector3:
	
	var target_position = target.global_position
	
	if center_object != null:
		target_position.x = center_object.global_position.x
		target_position.z = center_object.global_position.z
		
	return target_position	
	
	
func get_camera_new_position(camera_target_position: Vector3) -> Vector3:
	
	var target_position = camera_target_position
	var camera_new_position = target_position
	
	var horizontal_distance = tracking_distance * cos(phi)
	var vertical_distance = tracking_distance * sin(phi)
	
	camera_new_position.y += vertical_distance
	
	if target_position.x < 0:
		camera_new_position.x -= horizontal_distance * cos(theta)
	else:
		camera_new_position.x += horizontal_distance * cos(theta)
		
	if target_position.z < 0:
		camera_new_position.z -= horizontal_distance * sin(theta)
	else:
		camera_new_position.z += horizontal_distance * sin(theta)
	
	
	return camera_new_position
	
	
