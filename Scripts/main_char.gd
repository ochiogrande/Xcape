extends KinematicBody2D

var velocity: Vector2 = Vector2(0,0)
const UP = Vector2(0,-1)
onready var body: Node2D = $Body
var gravity: int = 1200
export var speed: int = 500
const SLOPE_STOP = 64
export var jump_velocity = -900
var is_grounded: bool
var dead: bool = false

onready var ground_check: Node2D = $GroundCheck #check for ground using raycasts


onready var background:Node = get_parent().get_node("paralax")
var current_mirroring: Vector2 = Vector2(3840, 0)


onready var player_cam: Camera2D = $Camera2D #camera for the main character

func _physics_process(delta):
	if dead == false:
		_get_input()
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, UP, SLOPE_STOP) 
		is_grounded = _check_is_grounded()
		if global.player_health <= 0:
			die()
		else:
			_assign_animation()
	pass
	
func _input(event):
		
	if event.is_action_pressed("jump") && is_grounded:
		velocity.y = jump_velocity
	pass
	
func _get_input():
	var dir = -int(Input.get_action_strength("move_left")) + int(Input.get_action_strength("move_right"))
	velocity.x = lerp(velocity.x, speed * dir, _get_h_weight())
	if dir != 0:
		body.scale.x = dir
		
	var zoom = Vector2(2.0,2.0) if velocity.x != 0 else Vector2(1.8,1.8)
	_change_zoom(zoom)

func _check_is_grounded() -> bool:
	#for raycast in ground_check.get_children():
	#	if raycast.is_colliding():
	#		return true
	#		
	#return false
	
	return is_on_floor()
	pass

func _get_h_weight() -> float:
	return 0.2 if is_grounded else 0.1
	pass
	
func _assign_animation(animation: String = "idle"):
	var anim = animation
	if dead == false:
		if !is_grounded:
			if velocity.y < 0:
				anim = "jump"
			else:
				anim = "fall"
		elif velocity.x != 0:
			anim = "run"
	else:
		anim = animation
		
	if body.get_child(0).animation != anim:
		body.get_child(0).play(anim)
		
		
func _change_zoom(zoom: Vector2) -> void:
	#var parallax_scale: bool = true if zoom.x == 2 else false
	#for bg in background.get_children():
	#	bg.scroll_ignore_camera_zoom = parallax_scale
	#change the zoom for the camera
	player_cam.zoom.x = lerp(player_cam.zoom.x, zoom.x, 0.005)
	player_cam.zoom.y = lerp(player_cam.zoom.y, zoom.y, 0.005)


func die() -> void:
	dead = true
	_assign_animation("die")
	$Timer.start()


func drown() -> void:
	dead = true
	_assign_animation("drown")
	$Timer.start()


func _on_Timer_timeout():
	global.player_lives -= 1
	if global.player_lives <= 0:
		get_tree().change_scene("res://GUI/GameOver.tscn")
	else: 
		global.player_health = 100
		self.position = global.check_point
		dead = false
