extends Node
#configuration variables :
var sound
var music
var is_pause

#player score variables
var potions_picked = 0
var coins_picked 
var player_health
var player_lives = 3
var player_level
var check_point = Vector2(510,-425)

func _ready():
	#settings variables initialisation
	is_pause = false
	sound = true
	music = true
	#player score variables initialisation
	player_health = 100
	coins_picked = 0
	player_lives = 3
	player_level = 1
	pass


func _process(delta):
	potions_picked = clamp(potions_picked, 0, 10)
	player_lives = clamp(player_lives, 0, 3)

