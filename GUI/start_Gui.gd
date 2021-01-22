extends Node


func _ready():
	pass

func on_sound_btn_released():
	if global.sound:
		global.sound = false
		$buttons/s_btn.set_texture(load("res://Sprites/Gui/Buttons/normal/soundoff_normal.png"))
	else:
		global.sound = true
		$buttons/s_btn.set_texture(load("res://Sprites/Gui/Buttons/normal/sound_normal.png"))
	pass
	
func on_music_btn_released():
	if global.music:
		global.music = false
		$buttons/m_btn.set_texture(load("res://Sprites/Gui/Buttons/normal/musicoff_normal.png"))
	else:
		global.music = true
		$buttons/m_btn.set_texture(load("res://Sprites/Gui/Buttons/normal/music_normal.png"))
	pass


func _on_Start_pressed():
	get_tree().change_scene("res://Levels/World1.tscn")

func _on_Credits_pressed():
	get_tree().change_scene("res://GUI/Credits.tscn")

func _on_Exit_pressed() -> void:
	#Exits the tree
	get_tree().quit()
