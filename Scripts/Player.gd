extends KinematicBody2D

const yDIRECTION = Vector2(0,-1) #can use vector2.UP
const ACCELARATION = 375
const MAX_SPEED = 750
const GRAVITY = 35
const JUMP_SPEED = 1300
var motion = Vector2()
var dead = false

onready var background:Node = get_parent().get_node("paralax")
var current_mirroring: Vector2 = Vector2(3840, 0)


onready var player_cam: Camera2D = $Camera2D #camera for the main character

func _physics_process(delta):
	if dead == false:
	#Movements physiques
		var friction = false
		motion.y += GRAVITY
		if Input.is_action_pressed("ui_right"):
			motion.x = min(motion.x+ACCELARATION,MAX_SPEED)
			$Sprite.flip_h = false # no flip
			_change_zoom(Vector2(2,2))
			$Sprite.play("run") 
			
		elif Input.is_action_pressed("ui_left"):
			motion.x = max(motion.x-ACCELARATION,-MAX_SPEED)
			$Sprite.flip_h = true #flip when left pressed
			$Sprite.play("run") 
			_change_zoom(Vector2(2,2))
		else:
			$Sprite.play("idle")
			_change_zoom(Vector2(1.8,1.8))
			friction = true
		if is_on_floor():
			if Input.is_action_pressed("ui_up"):
				if global.sound:
					$jump_sound.play()
				motion.y = -JUMP_SPEED
				
			if friction == true:
				motion.x = lerp(motion.x, 0 ,0.2)
		else:
			if friction == true:
				motion.x = lerp(motion.x, 0 ,0.05) #smooth stop
		if self.position.y > 120:
			drown()
		motion = move_and_slide(motion,Vector2.UP)
		if global.player_health <= 0:
			die()
			
		_play_anim()

#func _input(event) -> void:
	
	

func die():
	dead = true
	$Sprite.play("die")
	$Timer.start()

func drown():
	dead = true
	$Sprite.play("drown")
	$Timer.start()



func _on_Timer_timeout():
	global.player_lives -= 1
	if global.player_lives <= 0:
		get_tree().change_scene("res://GUI/GameOver.tscn")
	else: 
		global.player_health = 100
		self.position = global.check_point
		dead = false
		
func _change_zoom(zoom: Vector2) -> void:
	#var parallax_scale: bool = true if zoom.x == 2 else false
	#for bg in background.get_children():
	#	bg.scroll_ignore_camera_zoom = parallax_scale
	#change the zoom for the camera
	player_cam.zoom.x = lerp(player_cam.zoom.x, zoom.x, 0.007)
	player_cam.zoom.y = lerp(player_cam.zoom.y, zoom.y, 0.007)


func _play_anim() -> void:
	var anim = "idle"
	if !is_on_floor():
		if motion.y < 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("fall")
