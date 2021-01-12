extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const TURNING_SPEED = 20
func _ready():
	$Area2D.connect("body_entered",self,"player_touched")
	pass

func _physics_process(delta):
	self.rotate(PI + TURNING_SPEED)
	pass


func player_touched(body):
	if body.name == "Player":
		global.player_health -= 17

