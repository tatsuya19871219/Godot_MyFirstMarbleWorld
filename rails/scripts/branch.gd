@tool

extends Rail

const external_model_path = "res://rails/models/branch_15deg"

@export var gimmick_mesh_paths: Array[NodePath] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	try_load_external_model(external_model_path, [], false)
	init_extra_mesh_material()
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_extra_mesh_material():

	for mesh_path in gimmick_mesh_paths:
		if mesh_path != null:

			var mesh = get_node(mesh_path) as MeshInstance3D

			if mesh != null:
				mesh.material_override = extra_material



func _on_movable_unit_body_entered(body):
	#print("MovableUnit contacts ", body.name)
	pass

func _on_magnetic_field_body_entered(body):
	#print(body.name, " is in a magnetic field")
	pass
