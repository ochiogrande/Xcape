extends KinematicBody2D
const SPEED = 70
var direction = Vector2(1,0)
var mouvement = Vector2()
export(float, 0.0, 50.0) var damage: float = 15.0

onready var player: KinematicBody2D 

func _ready():
	$enemyArea.connect("body_entered",self,"player_touched")


func _physics_process(delta):
	if !$enemyArea/right.is_colliding():
		$enemyArea/Sprite.set_flip_h(true)
		direction.x = -1
	if !$enemyArea/left.is_colliding():
		$enemyArea/Sprite.set_flip_h(false)
		direction.x = 1 
	mouvement.x = SPEED*direction.x
	if !global.is_pause:
		move_and_slide(mouvement)


func player_touched(body):
	if body.name == "Player":
		global.player_health -= 15
		

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		modulate = Color(1,0,0)


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		modulate = Color(1,1,1)
