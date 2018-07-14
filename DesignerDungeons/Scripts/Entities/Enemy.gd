extends "res://Scripts/Entities/Entity.gd"

var target = null

export (int) var detect_radius

func _ready():
	$Detecter/DetectionRange.shape.radius = detect_radius

func _process(delta):
	if target:
		var direction = (target.global_position - global_position).normalized()
		global_rotation = direction.angle()

func _on_Detecter_body_entered(body):
	if body.name == "Player":
		target = body


func _on_Detecter_body_exited(body):
	if body == target:
		target = null
