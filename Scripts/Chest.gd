extends Area2D


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene("Levels/World2.tscn")
			global.check_point = Vector2(390,-590)
			global.player_level += 1
	pass
