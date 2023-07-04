@tool

extends Rail

const external_model_path = "res://rails/models/vertical_loop_%0.1fm"

@export_range(2.5, 10, 0.5) var diameter = 2.5:
	get:
		return diameter
	set(value):
		if try_load_external_model(external_model_path, [value]):
			diameter = value


# Called when the node enters the scene tree for the first time.
func _ready():
	
	try_load_external_model(external_model_path, [diameter])
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

