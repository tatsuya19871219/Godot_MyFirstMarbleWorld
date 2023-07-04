@tool

extends Node

@onready var ball_scene = preload("res://ball.tscn")

const cool_time = 0.5
var time_elapsed_from_last_ball = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	time_elapsed_from_last_ball += delta
	
	if time_elapsed_from_last_ball < cool_time:
		return
		
	if Input.is_key_label_pressed(KEY_A):
		
		generate_ball()
		time_elapsed_from_last_ball = 0


func _on_timer_timeout():
	generate_ball()
	
	
func generate_ball():
	if get_child_count() > 15: return
	
	var ball = ball_scene.instantiate()
	
	ball.global_position = $Marker3D.global_position
	add_child(ball)
	ball.freeze = false


func _enter_tree():
	if Engine.is_editor_hint():
		PhysicsServer3D.set_active(true)
		
func _exit_tree():
	if Engine.is_editor_hint():
		PhysicsServer3D.set_active(false)
