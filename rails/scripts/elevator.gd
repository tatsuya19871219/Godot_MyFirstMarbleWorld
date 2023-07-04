@tool

extends Node3D
#extends Rail

var elevator_info_verbose = false

@export_range(10, 50, 5) var height = 10:
	get:
		return height
	set(value):
		height = value
		build_elevator()

@export var material: StandardMaterial3D
@export var extra_material: StandardMaterial3D

const model_extension = ".glb"

@onready var elevator_entry_scene = preload("res://rails/models/elevator_entery_5m" + model_extension)
@onready var elevator_body_scene = preload("res://rails/models/elevator_body_5m" + model_extension)
@onready var elevator_exit_scene = preload("res://rails/models/elevator_exit_5m" + model_extension)

@export var speed = PI/2

@export var stopping_speed = PI

var is_stopped = false
var is_stopping = false


var components: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	build_elevator()


func build_elevator():
	var body_counts = (height - 10) / 5
	
	#print(body_counts)
	if elevator_exit_scene == null:
		print_elevator_info("not yet ready to build")
		return
	
	for c in components: 
		print_elevator_info("Try to remove: ", c.name)
		remove_child(c)
	components.clear()
	
	components.append(elevator_entry_scene.instantiate())
	for k in body_counts:
		components.append(elevator_body_scene.instantiate())
	components.append(elevator_exit_scene.instantiate())
	
	for i in components.size():
		components[i].position.y = i * 5.0
		
		#print(components[i].get_children())
		# set mesh colors
		for child in components[i].get_children():
			
			var mesh = child as MeshInstance3D
			
			if mesh == null: continue
			
			if mesh.name.contains("Rail"):
				#print(mesh)
				mesh.material_override = material
			else:
				mesh.material_override = extra_material
		
		add_child(components[i])

	print_elevator_info("Elevator build completed", components)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_stopping:
		for c in components:
			c.get_node("BarRail").rotation.y += stopping_speed * delta
		
		var rotation_progress = components[0].get_node("BarRail").rotation.y
		var remains = rotation_progress - roundf(rotation_progress/PI)*PI
		
		# stop if remains is small
		if absf(remains - PI/2) < PI/36:
			for c in components:
				c.get_node("BarRail").rotation.y = PI/2
				
			is_stopped = true
			is_stopping = false
	
	if not (is_stopping or is_stopped):
		for c in components:
			c.get_node("BarRail").rotation.y += speed * delta


func _on_elevator_entery_gate_entried():
	is_stopping = true


func _on_elevator_entery_gate_closed():
	is_stopped = false


func print_elevator_info(message, array = []):
	if elevator_info_verbose:
		print("[Elevator verbose] ", message) 
		if !array.is_empty():
			print("\t", array)
