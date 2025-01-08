extends Area2D

const SPEED := 1200
const RANGE := 1200
var travelled_distance = 0

var direction: Vector2 = Vector2.ZERO  # Направление движения
var knockback_velocity := 100

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
	
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()



func _on_body_entered(body):
	queue_free()  
	if body.has_method("_dead"):
		body._dead()
