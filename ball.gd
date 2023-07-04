@tool

extends RigidBody3D

var last_position

func _set(property, value):
	if (property == "freeze"):
		print("Setting freeze to ", value)
		if value:
			rotation = Vector3.ZERO
			position = Vector3.ZERO
			
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
		

# Called when the node enters the scene tree for the first time.
func _ready():
	
	last_position = position
	
	if Engine.is_editor_hint():
		freeze = true
	else:
		freeze = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
	pass # Replace with function body.
