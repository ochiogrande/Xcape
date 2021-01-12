extends CanvasLayer


func _physics_process(delta):
	$"Coins Score/Label".text = str(global.coins_picked)
	$"Player lives/Label".text = str(global.player_lives)
	$"HealthBar/ProgressBar".value = global.player_health
	$"Sprite/Potion_Label".text = str(global.potions_picked)
	pass







func _on_Potions_Button_pressed() -> void:
	if global.potions_picked > 0:
		global.player_health += 3
		global.potions_picked -= 1
