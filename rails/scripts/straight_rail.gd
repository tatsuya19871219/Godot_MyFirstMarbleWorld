@tool

extends Rail

@export_range(1, 50, 0.1) var length: float = 5.0:
	get:
		return length
	set(value):
		length = value
		if left_side_mesh != null:
			# this may be called before onready?
			_update_straight_rail()
			
@export var width = 1.0:
	get:
		return width
	set(value):
		width = value
		if left_side_mesh != null:
			_update_straight_rail()

@onready var left_side_mesh = $LeftSideRail
@onready var right_side_mesh = $RightSideRail

@onready var left_side_collision = $LeftSideRail/LeftSideRailBody/CollisionShape3D
@onready var right_side_collision = $RightSideRail/RightSideRailBody/CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var mesh = left_side_mesh.mesh.duplicate(true)
	var shape = left_side_collision.shape.duplicate(true)
	
	left_side_mesh.mesh = mesh
	right_side_mesh.mesh = mesh
	
	left_side_collision.shape = shape
	right_side_collision.shape = shape

	_update_straight_rail()
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _update_straight_rail():
	_update_rail_model()
	_update_marker_positions()
	_update_dockable_areas()


func _update_rail_model():
	left_side_mesh.mesh.height = length
	left_side_collision.shape.height = length
	
	left_side_mesh.position.z = - width/2
	right_side_mesh.position.z = width/2
	
	
func _update_marker_positions():
	$TailMarker.position = Vector3(-length/2.0, 0, 0)
	$HeadMarker.position = Vector3(length/2.0, 0, 0)
	
	
func _update_dockable_areas():
	clear_dockable_areas()
	init_dockable_areas()

