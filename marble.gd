class_name Marble extends RigidBody3D

@export var base_color: Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	$PointingArrow.modulate = base_color
	
	var material = $MeshInstance3D.mesh.material.duplicate()
	
	material.albedo_color = base_color
	
	$MeshInstance3D.material_override = material 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
