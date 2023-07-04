class_name ReversibleRail extends Rail


func update_rotation(condition: bool, value_true: float, value_false: float):

	#print("self child ", self.get_children(true))	

	if current_external_rail_scene == null:
		return
	
	if condition:
		current_external_rail_scene.rotation.x = value_true
	else:
		current_external_rail_scene.rotation.x = value_false
		
	clear_dockable_areas()
	init_dockable_areas()
