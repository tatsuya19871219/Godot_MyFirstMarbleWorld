@tool

extends ReversibleRail

const external_model_path = "res://rails/models/curve_%dm_%ddeg"

@export var right: bool = true:
	get:
		return right
	set(value):
		update_rotation(value, 0, PI)
		right = value

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
	update_rotation(right, 0, PI)
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	pass



