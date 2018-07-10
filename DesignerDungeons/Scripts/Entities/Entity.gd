extends KinematicBody2D

export (int) var speed
export (float) var shot_cooldown

var alive = true
var vel = Vector2(0, 0)

func _ready():
	$shoot_timer.wait_time = shot_cooldown
	

func control(delta):
	pass
	

func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_collide(vel)