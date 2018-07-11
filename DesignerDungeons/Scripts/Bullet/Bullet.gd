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

func hit():
	queue_free()

func _on_Bullet_body_entered(body):
	hit()
	if body.has_method('take_dmg'):
		body.take_dmg(1)


func _on_Life_timeout():
	hit()
