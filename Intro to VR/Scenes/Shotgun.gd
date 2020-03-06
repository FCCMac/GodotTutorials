extends RigidBody

var flash_mesh: MeshInstance
var flash_timer = 0
var raycasts
var BULLET_DAMAGE = 30

const FLASH_TIME = 0.25


func _ready():
	flash_mesh = $Shotgun_Flash
	flash_mesh.visible = false

	raycasts = $Raycasts

func _physics_process(delta):
	if flash_timer > 0:
		flash_timer -= delta
		if flash_timer <= 0:
			flash_mesh.visible = false


# Called when the interact button is pressed while the object is held.
func interact():

	if flash_timer <= 0:

		flash_timer = FLASH_TIME
		flash_mesh.visible = true

		for raycast in raycasts.get_children():

			raycast.rotation_degrees = Vector3(90 + rand_range(10, -10), 0, rand_range(10, -10))

			raycast.force_raycast_update()
			if raycast.is_colliding():

				var body = raycast.get_collider()

				if body.has_method("damage"):
					body.damage(raycast.global_transform, BULLET_DAMAGE)
				elif body.has_method("apply_impulse"):
					var direction_vector = raycast.global_transform.basis.z.normalized()
					body.apply_impulse((raycast.global_transform.origin - body.global_transform.origin).normalized(), direction_vector * 1.2)
		
		get_node("AudioStreamPlayer3D").play()


func picked_up():
	pass


func dropped():
	pass

