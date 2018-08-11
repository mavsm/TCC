extends KinematicBody2D

signal shoot
signal health_changed

export (PackedScene) var Bullet
export (int) var speed
export (float) var shot_cooldown
export (int) var max_hp

var alive = true
var vel = Vector2(0, 0)
var can_shoot = true
var hp

func _ready():
	$shoot_timer.wait_time = shot_cooldown
	hp =  max_hp
	emit_signal('health_changed', 100*hp/max_hp)


func control(delta):
	pass

func take_dmg(damage):
	emit_signal('health_changed', 100*hp/max_hp)
	hp -= damage
	if hp <= 0:
		die()

func die():
	pass

func shoot():
	if can_shoot:
		can_shoot = false
		$shoot_timer.start()
		var dir = Vector2(1, 0).rotated($Body.global_rotation)
		emit_signal('shoot', Bullet, $Body/spawn_point.global_position, dir)

func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_collide(vel)

func _on_shoot_timer_timeout():
	can_shoot = true
