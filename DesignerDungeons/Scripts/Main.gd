extends Node


func _on_shoot(bullet, pos, dir):
	var b = bullet.instance()
	add_child(b)
	prints("SHot!")
	b.start(pos, dir)