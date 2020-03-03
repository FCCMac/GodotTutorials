extends Control

var controller_one
var controller_two
var vignette_enabled = false


func _ready():
	for i in range(4):
		yield(get_tree(), "idle_frame")
	
	var interface = ARVRServer.primary_interface
	
	if interface == null:
		set_process(false)
		printerr("Movement_Vignette: no VR interface found!")
		return
	
	rect_size = interface.get_render_targetsize()
	rect_position = Vector2(0, 0)
	
	controller_one = get_parent().get_node("Left_Controller")
	controller_two = get_parent().get_node("Right_Controller")
	
	visible = false


func _process(delta):
	if (controller_one == null or controller_two == null):
		return
	
	if vignette_enabled:
		if (controller_one.directional_movement == true or controller_two.directional_movement == true):
			visible = true
		else:
			visible = false


