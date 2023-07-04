@tool

@icon("res://icons/rail.png")
class_name Rail extends Node3D

var rail_info_verbose = false

var external_model_extension = ".glb" #".blend"

var current_external_rail_scene: Node3D = null
var current_external_rail_path_args

var marker_paths: Array[NodePath] = []
var mesh_paths: Array[NodePath] = []
var extra_mesh_paths: Array[NodePath] = []

# Encountered this error
# https://github.com/godotengine/godot/issues/67144

@export var material: StandardMaterial3D = preload("res://materials/rail.tres")
@export var extra_material: StandardMaterial3D = preload("res://materials/extra.tres")

@onready var rail_root_node = self if current_external_rail_scene == null else current_external_rail_scene 

# This does not work
# See: https://github.com/godotengine/godot/issues/62916
#@export var markers: Array[Node3D] = []
#	get = get_markers, set = set_markers
#
#func get_markers():
#	#print("get markers")
#	return markers
#	#pass
#
#func set_markers(value):
#	print(value)
#	markers = value
#	notify_property_list_changed()
#	#pass

var dockable_areas: Array[DockableArea] = []

const docking_collision_layer = 4 # 0b100

class DockableArea extends Area3D:
	const length = 1.0
	const depth = 0.5
	const width = 2.0
	
	var parent_node: Node3D
	var areas_ignored: Array[DockableArea] = []
	
	var editor_interface
	
# Error constructing a GDScriptInstance
#	func _init(marker: Node3D, parent_node_override: Node3D = null):
#		position = marker.position
#		rotation = marker.rotation
#
#		#super._init()
#
#		#print("dockable area init")	
#
#		parent_node = parent_node_override
#
#		var collision_shape = CollisionShape3D.new()
#
#		collision_shape.shape = BoxShape3D.new()
#
#		collision_shape.shape.size = Vector3(length, depth, width)
#
#		add_child(collision_shape)
#		collision_shape.set_owner(self)
#		#collision_shape.set_owner(get_tree().edited_scene_root)
#
#		area_entered.connect(_on_area_entered)
			
	func set_marker(marker: Node3D, parent_node1: Node3D):
		
		if parent_node1 == null:
			print("Invalid parent node")
			return
			
		if marker == null:
			print("null marker")
			return
			
		parent_node = parent_node1
		
#		print("set marker parent node: ", parent_node)
		
		position = marker.position
		rotation = marker.rotation
		
		var collision_shape = CollisionShape3D.new()
		
		collision_shape.shape = BoxShape3D.new()
		
		collision_shape.shape.size = Vector3(length, depth, width)
		
		add_child(collision_shape)
		collision_shape.set_owner(self)
		#collision_shape.set_owner(get_tree().edited_scene_root)
		
		# for docking collision layer
		collision_layer = docking_collision_layer
		collision_mask = docking_collision_layer
		
		area_entered.connect(_on_area_entered)
		
	
	func set_ignored_areas(areas):
		areas_ignored = areas
		
		
	func _ready():
		if Engine.is_editor_hint():
			var plugin = (EditorPlugin as Variant).new()
			editor_interface = plugin.get_editor_interface()
		pass
		
	func _on_area_entered(area):
		
		#print(self, " on area entered ", area)
		#print("area name: ", area.name)
		
		if editor_interface == null:
			print("?")
			return
			
		if area in areas_ignored:
			#print("area is ignored")
			return
		
		var selected_nodes: Array = editor_interface.get_selection().get_selected_nodes()
		
		if selected_nodes.is_empty():
			return
		
#		if parent_node == null:
#			parent_node = self.get_parent()
#		print("parent: ", parent_node)
#		print("selected nodes:", selected_nodes)
		
		# If current selection contains self, modify own position 
		if parent_node in selected_nodes:
			var area_global_position = area.global_position
			
			for selected_node in selected_nodes:
				selected_node.global_position += area_global_position - self.global_position
			
			# de-select to preventing unexpected un-docking
			editor_interface.get_selection().clear()


	func _get_selected_nodes() -> Array[Node]:
		var selected_nodes = editor_interface.get_selection().get_selected_nodes()
		return selected_nodes


# Called when the node enters the scene tree for the first time.
func _ready():	
	if Engine.is_editor_hint():
		update_appearance()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_mesh_material():
	
	print_rail_info("init mesh: ...")
	print_rail_info(mesh_paths)
	print_rail_info(extra_mesh_paths)
	print_rail_info("...")
	
	for mesh_path in mesh_paths:
		
#		print(rail_root_node)
		#print(mesh_path)
#		print(material)
		
		if mesh_path != null:	
			var mesh = rail_root_node.get_node(mesh_path) as MeshInstance3D	
#			print(mesh)
			if mesh != null:
				mesh.material_override = material
				
	for mesh_path in extra_mesh_paths:
		
		if mesh_path != null:	
			var mesh = rail_root_node.get_node(mesh_path) as MeshInstance3D	
#			print(mesh)
			if mesh != null:
				mesh.material_override = extra_material


func init_dockable_areas():
	
	if not Engine.is_editor_hint(): return
	
	for marker_path in marker_paths:
		if marker_path != null:
			add_dockable_area(rail_root_node.get_node(marker_path))
			
	for area in dockable_areas:
		area.set_ignored_areas(dockable_areas)

	
func add_dockable_area(marker: Node3D):
	
	if not Engine.is_editor_hint(): return
	
	var dockable_area 
	
	dockable_area = DockableArea.new()
	dockable_area.set_marker(marker, self)
	rail_root_node.add_child(dockable_area)

	dockable_areas.append(dockable_area)


func clear_dockable_areas():
	
	if not Engine.is_editor_hint(): return
	
	#if dockable_areas.is_empty(): return
	print_rail_info("SC- ", self.get_children())
	if current_external_rail_scene != null:
		print_rail_info("Loaded Scene: " + current_external_rail_scene.to_string())
	if rail_root_node != null:
		print_rail_info("Rail root node: " + rail_root_node.to_string())
		print_rail_info("RC- ", rail_root_node.get_children())
	else:
		print_rail_info("Rail root node is currently null")
		return
	
	for dockable_area in dockable_areas:
		
		print_rail_info("Clear dockable area" + dockable_area.name)
		rail_root_node.remove_child(dockable_area)
		
	dockable_areas.clear()

	# for copied instance
	for child in rail_root_node.get_children():
		var area = child as DockableArea
		
		if area != null:
			print_rail_info("Clear dockable area (of copied instance)" + area.name)
			rail_root_node.remove_child(area)


# helper function for loading external model
func try_load_external_model(format_path, path_args, clear_children = true) -> bool:
	
#	print(format_path)
#	print(path_args)
	
	# is already loaded?
	if current_external_rail_path_args == path_args:
		return false
	
	clear_dockable_areas()
	
	var external_model_path = format_path % path_args
	external_model_path += external_model_extension

	print_rail_info("LOADING..", [external_model_path])
	
	var rail_scene = load(external_model_path)
		
	if rail_scene == null:
		return false
		
	if current_external_rail_scene != null:
		print_rail_info("MODEL UPDATED from: " +  current_external_rail_scene.name)
		remove_child(current_external_rail_scene)
	
	if not get_children().is_empty() and clear_children:
		print_rail_info("Instance is may be copied.")
		for child in get_children():
			remove_child(child)
	
	current_external_rail_scene = rail_scene.instantiate()
	current_external_rail_path_args = path_args
	
	add_child(current_external_rail_scene)
	
	rail_root_node = current_external_rail_scene
	
	print_rail_info("MODEL UPDATED to: " + current_external_rail_scene.name)
	
	update_appearance()
	
	return true


func update_appearance():
	
	#rail_root_node = current_external_rail_scene
	
	print_rail_info("=== Update appearance of the rail: " + rail_root_node.name + " ===")
	
	var rail_children = rail_root_node.get_children()
	print_rail_info(rail_children)
	mesh_paths.clear()
	marker_paths.clear()
	
	for child in rail_children:
		
		var child_node_path
		
#		if rail_root_node == self:
#			child_node_path = NodePath("%s" % [child.name])
#		else:
#			child_node_path = NodePath("%s/%s" % [rail_root_node.name, child.name])	

		child_node_path = NodePath("%s" % [child.name])
		print_rail_info("[path] ", [child_node_path])

		if child.name.contains("Rail"):
			print_rail_info("Update appearance of the rail child: " + child.name)
			mesh_paths.append(child_node_path)
		elif child.name.contains("Marker"):
			print_rail_info("Update appearance of the marker child: " + child.name)
			marker_paths.append(child_node_path)
		else:
			var extra_mesh = child as MeshInstance3D
			if extra_mesh != null:
				print_rail_info("Update appearance of the extra mesh child: " + child.name)
				extra_mesh_paths.append(child_node_path)
			
		
	#notify_property_list_changed()

	#
	init_mesh_material()
	
	init_dockable_areas()

	
func print_rail_info(message, array = []):
	if rail_info_verbose:
		print("[Rail verbose] ", message) 
		if !array.is_empty():
			print("\t", array)
