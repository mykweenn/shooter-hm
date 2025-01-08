extends Node

@export var controller : CharacterBody3D
@export_range(0.0, 500.0, 0.1) var force : float = 100.0
@export var enabled : bool = false

func _physics_process(delta):
	if enabled and controller.get_slide_collision_count() > 0:
		var colission = controller.get_last_slide_collision()
		if colission.get_collider() is RigidBody2D:
			var direction = -colission.get_normal()
			var speed = clamp(controller.velocity.length(), 1.0, 10.0)
			var impulse_position = colission.get_position() - colission.get_collider().global_position
			colission.get_collider().apply_impulse(direction * speed * force, impulse_position)
