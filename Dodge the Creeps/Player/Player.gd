extends Area2D

signal hit

export var speed = 400
var screen_size

var target = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
	
func _process(delta):
	var velocity = Vector2()
	
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * speed
	else:
		velocity = Vector2()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false

