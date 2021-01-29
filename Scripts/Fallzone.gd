extends Area2D

onready var area: CollisionShape2D = $CollisionShape2D
export (Vector2) var scale_shape: Vector2 = Vector2(541.0, 142.0)

func _ready():
	
	area.shape.extents = scale_shape
