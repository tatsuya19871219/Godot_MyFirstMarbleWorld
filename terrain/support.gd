@tool

class_name Support extends Node3D

@export var height = 10.0:
	get:
		return height
	set(value):
		if Engine.is_editor_hint():
			if value > 0:
				height = value
				update_model()
		else:
			height = value

@export var angle = 0.0:
	get:
		return angle
	set(value):
		if Engine.is_editor_hint():
			angle = value
			update_model()
		else:
			angle = value


@onready var pole_mesh = $SupportBody/PoleMesh.mesh.duplicate()
@onready var pole_collision = $SupportBody/PoleCollisionShape.shape.duplicate()
@onready var ring_area_collision = $Ring/RingMesh/RingArea/CollisionShape3D.shape.duplicate()

@onready var light_on_material = preload("res://materials/light_on.tres")
@onready var light_off_material = preload("res://materials/light_off.tres")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$SupportBody/PoleMesh.mesh = pole_mesh
	$SupportBody/PoleCollisionShape.shape = pole_collision
	$Ring/RingMesh/RingArea/CollisionShape3D.shape = ring_area_collision
	
	update_model()
	
	$Ring/RingMesh/Light.mesh.material = light_off_material
	$Ring/RingMesh/Light.material_override = null
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_model():
	
	if height <= 0: return
	if pole_mesh == null: return
	
	# to avoid collision detect of self structure
	$Ring/RingMesh/RingArea.monitorable = false
	$Ring.position.y = height
	$Ring.rotation.z = angle

	pole_mesh.height = height
	pole_collision.height = height

	$SupportBody/PoleMesh.position.y = height/2
	$SupportBody/PoleCollisionShape.position.y = height/2
	
	$Ring/RingMesh/RingArea.monitorable = true


func _on_ring_area_body_entered(body):
	
	if body is StaticBody3D: return
	
	#print("Entered: ", body.name, " [StaticBody]", body is StaticBody3D)
	
	$Ring/RingMesh/Light.material_override = light_on_material


func _on_ring_area_body_exited(body):
	
	if body is StaticBody3D: return

#	print("Exited: ", body.name, " [StaticBody]", body is StaticBody3D)
	
	$Ring/RingMesh/Light.material_override = null
