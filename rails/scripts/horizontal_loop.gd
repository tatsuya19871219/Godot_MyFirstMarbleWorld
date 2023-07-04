@tool

extends Rail

const external_model_path = "res://rails/models/horizontal_loop_%dm_%0.1fm"

@export_range(5, 15, 5) var diameter = 5:
	get:
		return diameter
	set(value):
		if try_load_external_model(external_model_path, [value, height]):
			diameter = value
		else:
			print("CAUTION: model is not updated")
			diameter = value
			
@export_range(2.5, 10.0, 2.5) var height = 5.0:
	get:
		return height
	set(value):
		if try_load_external_model(external_model_path, [diameter, value]):
			height = value
		else:
			print("CAUTION: model is not updated")
			height = value
			
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#print(external_model_path % [diameter, height])
	try_load_external_model(external_model_path, [diameter, height])
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

