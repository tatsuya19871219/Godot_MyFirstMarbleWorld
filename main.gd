extends Node

@export var base_colors: Array[Color]

@onready var marble_scene = preload("res://marble.tscn")

var marbles: Array[Marble] = []

var detection_target_marble: Marble

# Called when the node enters the scene tree for the first time.
func _ready():
	$CameraViewportsTracking/Panel/BallTrackingView.visible = false
	$CameraViewportsTracking/Panel/ElevatorTrackingView.visible = false
	$CameraViewportsTracking/BallTrackingWideView.visible = false
	$CameraViewports_Course.visible = false
	$CameraViewportsTracking.visible = false
	$CameraViewports_Start.visible = true
	
	for i in range($MarbleCourseContainer/Structures/MarbleStand.holes):
		var marble = marble_scene.instantiate()
		var hole_position = $MarbleCourseContainer/Structures/MarbleStand.get_current_hole_position()
		marble.position = hole_position
		#marble.base_color = Color.BLACK
		marble.base_color = base_colors[i]
		add_child(marble)
		marbles.append(marble)
		
	$MarbleCourseContainer/Cameras/BallTrackingViewport/BallTrackingCam.set_tracking_target(marbles[0])
	$MarbleCourseContainer/Cameras/BallTrackingWideViewport/BallTrackingCam.set_tracking_target(marbles[0])
	$MarbleCourseContainer/Cameras/BallTrackingViewport_Elevator/ElevatorTrackingCam.set_tracking_target(marbles[0])

	detection_target_marble = marbles[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_area_check_point_body_entered(body):
	
	if body == detection_target_marble:
		print(body, " is entered in the start area check point.")
		$CameraViewportsTracking.visible = true
		$CameraViewportsTracking/Panel.visible = true
		$CameraViewportsTracking/Panel/BallTrackingView.visible = true
		$MarbleCourseContainer/ViewportTriggers/StartAreaCheckPoint.set_deferred("monitoring", false)


func _on_elevator_entry_area_check_point_body_entered(body):
	
	if body == detection_target_marble:
		print(body, " is entered in the elevator entry area check point.")
		$CameraViewportsTracking/Panel.visible = true
		$CameraViewportsTracking/Panel/BallTrackingView.visible = false
		$CameraViewportsTracking/Panel/ElevatorTrackingView.visible = true
		$MarbleCourseContainer/ViewportTriggers/ElevatorEntryAreaCheckPoint.set_deferred("monitoring", false)
		


func _on_elevator_exit_area_check_point_body_entered(body):
	
	if body == detection_target_marble:
		print(body, " is entered in the elevator exit area check point.")
		$CameraViewportsTracking/Panel/ElevatorTrackingView.visible = false
		$CameraViewportsTracking/Panel.visible = false
		$CameraViewportsTracking/BallTrackingWideView.visible = true
		$MarbleCourseContainer/ViewportTriggers/ElevatorExitAreaCheckPoint.set_deferred("monitoring", false)
		$CameraViewports_Start.visible = false
		$CameraViewports_Course.visible = true
		$MarbleCourseContainer/ViewportTriggers/FunnelAreaCheckPoint.set_deferred("monitoring", true)


func _on_funnel_area_check_point_body_entered(body):
	
	if body == detection_target_marble:
		print(body, " is entered in the funnel area check point.")
		$CameraViewportsTracking/BallTrackingWideView.visible = false
		$CameraViewports_Start.visible = true
		$MarbleCourseContainer/ViewportTriggers/FunnelAreaCheckPoint.set_deferred("monitoring", false)
		$MarbleCourseContainer/ViewportTriggers/ElevatorEntryAreaCheckPoint.set_deferred("monitoring", true)
		$MarbleCourseContainer/ViewportTriggers/ElevatorExitAreaCheckPoint.set_deferred("monitoring", true)
