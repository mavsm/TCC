extends "res://Scripts/Entities/Entity.gd"

signal died

#Implements player movement
func control(delta):
	$Body.look_at(get_global_mouse_position())
	$Collision.look_at(get_global_mouse_position())
	"""if Input.is_action_pressed('look_up'):
		$Body.rotation_degrees = 270
	elif Input.is_action_pressed('look_down'):
		$Body.rotation_degrees = 90
	elif Input.is_action_pressed('look_right'):
		$Body.rotation_degrees = 0
	elif Input.is_action_pressed('look_left'):
		$Body.rotation_degrees = 180
	"""
	
	if Input.is_action_pressed('walk_up'):
		vel = Vector2(0, -speed)*delta
	elif Input.is_action_pressed('walk_down'):
		vel = Vector2(0, speed)*delta
	elif Input.is_action_pressed('walk_right'):
		vel = Vector2(speed, 0)*delta
	elif Input.is_action_pressed('walk_left'):
		vel = Vector2(-speed, 0)*delta
	else:
		vel = .7*vel
	
	if Input.is_action_pressed("shoot"):
		shoot()
		
func set_limits(x, y):
	$Camera2D.limit_right = x
	$Camera2D.limit_bottom = y

func die():
	emit_signal("died")

func _on_AnimationPlayer_animation_finished(anim_name):
	invincible = false


func _on_Player_took_hit():
	invincible = true
	$AnimationPlayer.play("Invincibility")
