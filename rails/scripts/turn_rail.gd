@tool

extends ReversibleRail

const external_model_path = "res://rails/models/turn_%ddeg"

@export_range(90, 180, 90) var angle = 90:
	get:
		return angle
	set(value):
		if try_load_external_model(external_model_path, [value]):
			angle = value

# Called when the node enters the scene tree for the first time.
func _ready():
	
	try_load_external_model(external_model_path, [angle])
	
	super()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
