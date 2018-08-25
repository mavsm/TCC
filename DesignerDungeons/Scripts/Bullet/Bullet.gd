extends Area2D

export (int) var speed
export (float) var lifetime

var vel = Vector2()

func start(pos, dir):
	position = pos
	rotation = dir.angle()
	$Life.wait_time = lifetime
	vel = dir * speed

func _process(delta):
	position += vel*delta
	"""
	$Sprite.scale *= .988
	$Collision.scale *= .988
	"""

func hit():
	$Sprite.hide()
	$Collision.disabled = true
	set_process(false)
	$Life.stop()
	$AnimatedSprite.play()

func _on_Bullet_body_entered(body):
	if body.has_method('take_dmg'):
		body.take_dmg(1)
	hit()


func _on_Life_timeout():
	perish()

func perish():
	queue_free()

func _on_AnimatedSprite_animation_finished():
	perish()
