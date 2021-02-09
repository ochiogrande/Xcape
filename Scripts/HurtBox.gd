extends Area2D

export var knockback_speed: int = 500
var hurting: bool = false
var dir: int
onready var player: KinematicBody2D = get_parent()
onready var Body: Node2D = player.get_child(0)


func _physics_process(delta):
	
	if hurting == true:
		_get_hurt()
		player.velocity.y += player.gravity * delta


func _get_hurt() -> void:
		
		var move_dir: int
		if player.direction != dir:
			move_dir = dir
		else:
			move_dir = -dir
		player.velocity.x = lerp(player.velocity.x, knockback_speed * move_dir, 0.3)
		player.velocity.y = lerp(player.velocity.y, -320, 0.1) if !player.is_grounded else 0
		Body.get_child(0).play("hurt")
		player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
		
		
func _hit_effect(direction: int) -> void:
		
		hurting = true
		dir = direction
		$Timer.start()


func _on_Timer_timeout() -> void:
	
		hurting = false
		pass # Replace with function body.
