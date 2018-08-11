extends "res://Scripts/Entities/Entity.gd"

signal died

#Implements player movement
func control(delta):
	$Body.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed('walk_up'):
		vel = Vector2(0, -speed)*delta
	elif Input.is_action_pressed('walk_down'):
		vel = Vector2(0, speed)*delta
	elif Input.is_action_pressed('walk_right'):
		vel = Vector2(speed, 0)*delta
	elif Input.is_action_pressed('walk_left'):
		vel = Vector2(-speed, 0)*delta
	else:
		vel = Vector2(0, 0)
	
	if Input.is_action_pressed("shoot"):
		shoot()
		
func set_limits(x, y):
	$Camera2D.limit_right = x
	$Camera2D.limit_bottom = y

func die():
	#alive = false
	print("DIED")
	emit_signal("died")