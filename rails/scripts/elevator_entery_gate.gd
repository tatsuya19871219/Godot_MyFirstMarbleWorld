@tool

extends Node3D

var elevator_info_verbose = false

signal entried
signal opened
signal closed

var is_opening = false
var is_closing = false

var gate_speed = PI

# Called when the node enters the scene tree for the first time.
func _ready():
	
	close_immidiate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if is_opening:
		if absf($EntryHoleDoor.rotation.z - PI*4/5) < PI/36:
			$EntryHoleDoor.rotation.z = PI*4/5
			opened.emit()
			is_opening = false
	
		$EntryHoleDoor.rotation.z += gate_speed * delta
		
	if is_closing:
		if absf($EntryHoleDoor.rotation.z - 0) < PI/36:
			$EntryHoleDoor.rotation.z = 0
			closed.emit()
			is_closing = false
			
		$EntryHoleDoor.rotation.z -= gate_speed * delta
	

func open():
	if is_closing: is_closing = false
	is_opening = true


func close():
	if is_opening: is_opening = false
	is_closing = true


func close_immidiate():
	$EntryHoleDoor.rotation.z = 0


func _on_gate_front_area_body_entered(body):
	print_elevator_info("[gate] body entered")
	print_elevator_info("(Body) ", body.name)
	close()


func _on_entry_rail_area_body_entered(body):
	print_elevator_info("[gate] entry")
	print_elevator_info("(Body) ", body.name)
	entried.emit()
	open()

func print_elevator_info(message, array = []):
	if elevator_info_verbose:
		print("[Elevator Gate verbose] ", message) 
		if !array.is_empty():
			print("\t", array)
