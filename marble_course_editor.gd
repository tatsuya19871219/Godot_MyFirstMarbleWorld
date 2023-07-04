@tool

class_name RailCourseEditor extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _enter_tree():
	if Engine.is_editor_hint():
		PhysicsServer3D.set_active(true)
		
func _exit_tree():
	if Engine.is_editor_hint():
		PhysicsServer3D.set_active(false)
