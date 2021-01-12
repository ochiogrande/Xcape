extends Node


func _on_Exit_pressed():
	get_tree().change_scene("res://GUI/start_Gui.tscn")
	global.player_lives = 3
	global.check_point = Vector2(390,-590)
	global.potions_picked = 0

