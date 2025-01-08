extends CharacterBody2D


const speed = 60
#@export var player: Node2D
@onready var player = get_node("/root/Game/Player")
var hp = 20


var knockback_velocity: Vector2
var min_knockback := 10
var slow_knockback := 1.1

# blood vfx
var blood = preload("res://Scenes/VFX/blood_particles.tscn")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	collide_with_body()
	move_and_slide()
	
	if knockback_velocity.length() > min_knockback:
		knockback_velocity /= slow_knockback
		velocity = knockback_velocity
		move_and_slide()
		return

func _process(delta):
	if player.global_position > global_position:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true


func collide_with_body():
	for i in get_slide_collision_count():
		var obj = get_slide_collision(i).get_collider()
		if obj is CharacterBody2D and obj.name == "Player":
			obj.take_damage()
		


func taking_damage():
	hp -= 10
	var blood_inst = blood.instantiate()
	blood_inst.global_position = global_position
	get_tree().get_root().add_child(blood_inst)
	if hp <= 0:
		queue_free()
