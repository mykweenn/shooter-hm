extends CharacterBody2D

@onready var ray_cast = $RayCasts/RayCast2D
@onready var timer = $Timer
@onready var bullet_area = preload("res://Scenes/bullet_area.tscn")

@onready var player = get_node("/root/Game/Player")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

#wander
var wander_timer = 0.0
var time_to_change_dir = 2
var move_dir = Vector2.ZERO
var move_speed = 50
var rotation_speed = 5.0
var acceleration = 0.5

#dead
var is_dead := false

#spot
var player_in_area := false

#legs
@onready var legs_anim = $Legs/LegsAnimatedSprite2D


func _physics_process(delta):
	if !is_dead:
		_aim()
		_check_player_collision()
		_wander(delta)
		
	

func _aim():
	ray_cast.target_position = to_local(player.position)


func _check_player_collision():
	if player_in_area:
		look_at(player.global_position)
		if ray_cast.get_collider() == player and timer.is_stopped():
			timer.start()
		elif ray_cast.get_collider() != player and not timer.is_stopped():
			timer.stop()

func _on_timer_timeout():
	_shoot()


func _wander(delta):
	if !player_in_area:
		wander_timer += delta
		if wander_timer >= time_to_change_dir:
			wander_timer = 0
			move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

		var target_angle = move_dir.angle()  # Угол нового направления
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)  # Плавно изменяем угол
		velocity = move_dir * move_speed
		set_velocity(lerp(velocity, move_dir * move_speed, acceleration * delta))

		move_and_slide()
	if velocity.length() > 0.0:
		legs_anim.play("run")
		$Legs.look_at(position + velocity)
		legs_anim.flip_h = velocity.x < 0
		legs_anim.flip_v = velocity.y < 0
	else:
		legs_anim.play("idle")




func _shoot():
	if !is_dead and player_in_area:
		
		var bullet_instance = bullet_area.instantiate() 
		bullet_instance.global_position = %ShotPoint.global_position 
		bullet_instance.global_rotation = %GunPivot.global_rotation 
		get_parent().add_child(bullet_instance) 
		#$GunPivot/GunshotAudio2D.play()
		await get_tree().create_timer(0.2).timeout 


func _dead():
	is_dead = true
	animated_sprite_2d.play("death")
	animated_sprite_2d.flip_h = true
	collision_shape_2d.disabled = true
	animated_sprite_2d.z_index = 0
	legs_anim.play("idle")
	


func _on_spot_area_2d_body_entered(body):
	if body.name == "Player":
		player_in_area = true


func _on_spot_area_2d_body_exited(body):
	if body.name == "Player":
		player_in_area = false
