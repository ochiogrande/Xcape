extends KinematicBody2D

const yDIRECTION = Vector2(0,-1) #can use vector2.UP
const ACCELARATION = 375
const MAX_SPEED = 750
const GRAVITY = 35
const JUMP_SPEED = 1300
var motion = Vector2()
var dead = false

onready var background: Node2d = $paralax
onready var current_mirroring: Vector2 = background.get_child(0).get_child(0).motion_mirroring


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
			_change_zoom(Vector2(2,2))
			$Sprite.play("run") 
		else:
			_change_zoom(Vector2(1.8,1.8))
			$Sprite.play("idle")
			friction = true
		if is_on_floor():
			if Input.is_action_pressed("ui_up"):
				if global.sound:
					$jump_sound.play()
				motion.y = -JUMP_SPEED
			if friction == true:
				motion.x = lerp(motion.x, 0 ,0.2)
		else:
			if motion.y < 0 :
				$Sprite.play("jump")
			else:
				$Sprite.play("fall")
			if friction == true:
				motion.x = lerp(motion.x, 0 ,0.05) #smooth stop
		if self.position.y > 120:
			drown()
		motion = move_and_slide(motion,Vector2.UP)
		if global.player_health <= 0:
			die()

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
    var parallax_scale = 0.2 if zoom.x == 2 else 1
    for bg in background.get_children():
        var parallax_layer = bg.get_child(0)
        parallax_layer.motion_mirroring.x = lerp(parallax_layer.motion_mirroring.x, current_mirroring.x * parallax_scale, 0.04)
	#change the zoom for the camera
	player_cam.zoom.x = lerp(player_cam.zoom.x, zoom.x, 0.05)
	player_cam.zoom.y = lerp(player_cam.zoom.y, zoom.y, 0.05)
