@tool

extends ReversibleRail

const external_model_path = "res://rails/models/slope_%dm_%ddeg"

@export var up = true:
	get:
		return up
	set(value):
		up = value
		update_rotation(up, 0, PI)
		
@export_range(5, 5, 5) var length = 5
@export_range(15, 60, 15) var angle = 15:
	get:
		return angle
	set(value):
		if try_load_external_model(external_model_path, [length, value]):
			angle = value
			
# Called when the node enters the scene tree for the first time.
func _ready():
	
	try_load_external_model(external_model_path, [length, angle])
	update_rotation(up, 0, PI)
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
