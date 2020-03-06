extends RigidBody

var bomb_mesh: MeshInstance
var fuse_timer = 0
var explosion_area: Area
var explosion_timer = 0
var explode = false
var fuse_particles: Particles
var explosion_particles: Particles
var controller = null

const FUSE_TIME = 4
const EXPLOSION_DAMAGE = 100
const EXPLOSION_TIME = 0.75

func _ready() -> void:
	bomb_mesh = $Bomb
	explosion_area = $Area
	fuse_particles = $Fuse_Particles
	explosion_particles = $Explosion_Particles
	
	set_physics_process(false)


func _physics_process(delta) -> void:
	if fuse_timer < FUSE_TIME:
		fuse_timer += delta
		
		if fuse_timer >= FUSE_TIME:
			fuse_particles.emitting = false
			explosion_particles.one_shot = true
			explosion_particles.emitting = true
			bomb_mesh.visible = false
			
			collision_layer = 0
			collision_mask = 0
			mode = RigidBody.MODE_STATIC
			
			for body in explosion_area.get_overlapping_bodies():
				if body == self:
					pass
				else:
					if body.has_method("damage"):
						body.damage(global_transform.looking_at(body.global_transform.origin, Vector3(0, 1, 0)), EXPLOSION_DAMAGE)
					elif body.has_method("apply_impulse"):
						var direction_vector = body.global_transform.origin - global_transform.origin
						body.apply_impulse(direction_vector.normalized(), direction_vector.normalized() * 1.8)
			
			explode = true
			$AudioStreamPlayer3D.play()
	
	if explode:
		explosion_timer += delta
		if explosion_timer >= EXPLOSION_TIME:
			explosion_area.monitoring = false
			
			if controller != null:
				controller.held_object = null
				controller.hand_mesh.visible = true
				
				if controller.grab_mode == "RAYCAST":
					controller.grab_raycast.visible = true
			
			queue_free()


func interact():
	set_physics_process(true)
	fuse_particles.emitting = true


func picked_up():
	pass


func dropped():
	pass

