extends Spatial

var spheres_left = 10
var sphere_ui = null


func _ready():
	var VR = ARVRServer.find_interface("OpenVR")
	if VR and VR.initialize():
		get_viewport().arvr = true
		get_viewport().hdr = false
		
		OS.vsync_enabled = false
		Engine.target_fps = 90


func remove_sphere() -> void:
	spheres_left -= 1
	
	if sphere_ui != null:
		sphere_ui.update_ui(spheres_left)

