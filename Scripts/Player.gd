extends KinematicBody2D

const yDIRECTION = Vector2(0,-1)
const ACCELARATION = 375
const MAX_SPEED = 750
const GRAVITY = 35
const JUMP_SPEED = 1300
var motion = Vector2()
var dead = false

func _physics_process(delta):
	if dead == false:
	#Movements physiques
		var friction = false
		motion.y += GRAVITY
		if Input.is_action_pressed("ui_right"):
			motion.x = min(motion.x+ACCELARATION,MAX_SPEED)
			$Sprite.flip_h = false # no flip 
			$Sprite.play("run") 
		elif Input.is_action_pressed("ui_left"):
			motion.x = max(motion.x-ACCELARATION,-MAX_SPEED)
			$Sprite.flip_h = true #flip when left pressed
			$Sprite.play("run") 
		else:
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
		motion = move_and_slide(motion,yDIRECTION)
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
