extends RigidBody

var flash_mesh: MeshInstance
var flash_timer = 0
var laser_sight_mesh: MeshInstance
var raycast: RayCast

const FLASH_TIME = 0.25
const BULLET_DAMAGE = 20


func _ready() -> void:
	flash_mesh = $Pistol_Flash
	flash_mesh.visible = false
	
	laser_sight_mesh = $LaserSight
	laser_sight_mesh.visible = false
	
	raycast = $RayCast


func _physics_process(delta) -> void:
	if flash_timer > 0:
		flash_timer -= delta
		
		if flash_timer <= 0:
			flash_mesh.visible = false


func interact() -> void:
	if flash_timer <= 0:
		flash_timer = FLASH_TIME
		flash_mesh.visible = true
		
		raycast.force_raycast_update()
		if raycast.is_colliding():
			var body = raycast.get_collider()
			
			if body.has_method("damage"):
				body.damage(raycast.global_transform, BULLET_DAMAGE)
			elif body.has_method("apply_impulse"):
				var direction_vector = raycast.global_transform.basis.z.normalized()
				body.apply_impulse((raycast.global_transform.origin - body.global_transform.origin).normalized(), direction_vector * 1.2)
		
		$AudioStreamPlayer3D.play()


func picked_up() -> void:
	laser_sight_mesh.visible = true


func dropped() -> void:
	laser_sight_mesh.visible = false

