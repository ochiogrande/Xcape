extends KinematicBody2D

var WALK_SPEED = 80
var direction = Vector2(1,0)
var mouvements = Vector2()
export(int, 1, 50) var damage: int = 15

func _ready():
	$Area2D.connect("body_entered",self,"player_touched")
	pass

func _physics_process(delta):
	if !$Area2D/right_limit.is_colliding():
		direction.x = -1
		$Area2D/AnimatedSprite.set_flip_h(true)
	if !$Area2D/left_limit.is_colliding():
		direction.x = 1
		$Area2D/AnimatedSprite.set_flip_h(false)
	mouvements.x = WALK_SPEED*direction.x
	if !global.is_pause:
		move_and_slide(mouvements)

func flip_attack():
	#print(get_node("../Player").position.x)
	#print(self.position.x)
	if self.position.x > get_node("../Player").position.x:
		direction.x = -1
		$Area2D/AnimatedSprite.set_flip_h(true)
	if self.position.x < get_node("../Player").position.x:
		direction.x = 1
		$Area2D/AnimatedSprite.set_flip_h(false)

func player_touched(body):
	if body.name == "Player":
		#global.player_health -= 15
		$Area2D/AnimatedSprite.play("attack")
		WALK_SPEED = 0
		flip_attack()
		$attacktimer.start()

func _on_Area2D_body_exited(body):
	$Area2D/AnimatedSprite.play("idle")

func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		modulate = Color(1,0,0)
#		$Area2D/AnimatedSprite.play("alert")
		WALK_SPEED = 0

func _on_Area2D2_body_exited(body):
	if body.name == "Player":
		modulate = Color(1,1,1)
#		$Area2D/AnimatedSprite.play("idle")
		WALK_SPEED = 80

func _on_attacktimer_timeout(body):
	$Area2D/AnimatedSprite.play("idle")
	if body.name == "Player":
		$Area2D/AnimatedSprite.play("attack")
		_on_Area2D_body_exited("Player")
