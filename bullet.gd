extends RigidBody2D

var motion = Vector2()


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _physics_process(delta):
	var collide = move_and_collide(motion * delta)
	if collide:
		if collide.get_collider().has_method("taking_damage"):
			collide.get_collider().taking_damage()
		$CollisionShape2D.disabled = true
		queue_free()
