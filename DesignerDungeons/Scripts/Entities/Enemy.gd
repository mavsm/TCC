extends "res://Scripts/Entities/Entity.gd"

var target = null

var small = false
var follow = false
var armor = false
var passthrough = false

var armorSprite1 = preload("res://Assets/EnemyMed.png")
var passthroughBullet = preload("res://Scenes/Bullet/PassThroughBullet.tscn")

export (int) var detect_radius

func _ready():
	$Detecter/DetectionRange.shape.radius = detect_radius

func die():
	queue_free()

func _process(delta):
	if target:
		var direction = (target.global_position - global_position).normalized()
		global_rotation = direction.angle()
		shoot()

func _on_Detecter_body_entered(body):
	if body.name == "Player":
		target = body


func _on_Detecter_body_exited(body):
	if body == target:
		target = null


func _on_IsVisible_screen_entered():
	set_process(true)
	$Collision.disabled = false
	$Detecter/DetectionRange.disabled = false


func _on_IsVisible_screen_exited():
	set_process(false)
	$Collision.disabled = true
	$Detecter/DetectionRange.disabled = true

func diff_properties(diff):
	shot_cooldown = min(1 - diff/11 + 0.2, .6)
	detect_radius = 200 + max(2*diff*10, 100)
	for i in range(diff/3):
		var type = rand_range(0, 3)
		if !small and type < 1 : #small enemy
			small = true
			$Body.scale = Vector2(.4,.4)
			$Collision.scale = Vector2(.4,.4)
		elif !armor and type < 2: #armor
			$Body.texture = armorSprite1
			armor = true
			max_hp = 10
			hp = 10
		elif !passthrough and type < 3:
			passthrough = true
			Bullet = passthroughBullet