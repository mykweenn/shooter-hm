extends CharacterBody2D

@export var speed : int = 100
var input_vector = Vector2.ZERO

var can_fire = true 
var bullet = preload("res://Scenes/bullet.tscn") 
var bullet_area = preload("res://Scenes/bullet_area.tscn")
var bullet_speed = 1000 
var ammo = 8
var can_reload = true
@onready var legs_anim = $Legs/LegsAnimatedSprite2D
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var camera = $Camera2D

@export var hp = 100.0

#slowmo
@export var force : float = 0.2 # Переменная ответающая за то на сколько будет замедлятся игра

# game states

signal player_is_dead
var is_dead := false


func _physics_process(delta):
	gun()
	movement()
	handle_movement()
	
	if Input.is_action_pressed("LMB"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		reload()

func movement():
	if !is_dead:
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		
		velocity = input_vector * speed

		move_and_slide()


func handle_movement():
	# Печатаем вектор скорости, чтобы проверить
	print(velocity)
	if !is_dead:
		if velocity.length() > 0.0:
			legs_anim.play("run")
			animated_sprite_2d.play("walk")
			$Legs.look_at(position + velocity)
			legs_anim.flip_h = velocity.x < 0
			legs_anim.flip_v = velocity.y < 0
		else:
			legs_anim.play("idle")
			animated_sprite_2d.play("idle")

func gun():
	if !is_dead:
		look_at(get_global_mouse_position())

func shoot():
	if can_fire and ammo != 0 and can_reload: 
		camera.shake(0.2, 0.6)
		var bullet_instance = bullet_area.instantiate() 
		bullet_instance.global_position = %ShotPoint.global_position 
		bullet_instance.global_rotation = %GunPivot.global_rotation 
		get_parent().add_child(bullet_instance) 
		ammo -= 1
		$GunPivot/GunshotAudio2D.play()
		can_fire = false 
		animated_sprite_2d.play("shoot")
		await get_tree().create_timer(0.2).timeout 
		can_fire = true 
	if Global.slowmo == true:
		$GunPivot/GunshotAudio2D.pitch_scale = 0.8
	else:
		$GunPivot/GunshotAudio2D.pitch_scale = 1

func reload():
	if can_reload:
		$GunPivot/ReloadAudio2D.play()
		can_reload = false
		await get_tree().create_timer(0.4).timeout 
		can_reload = true
		ammo = 8


func take_damage():
	hp -= 1
	print(hp)
	if hp == 0:
		print('dead')
		_dead()


func _input(event):
	slowmotion()

func slowmotion():
	if Input.is_action_just_pressed("slowmo"): # Проверяем, была ли нажата кнопка "slowmo"
		Global.slowmo = not Global.slowmo # Меняем значение переменной Global.slowmo на противоположное
		if Global.slowmo == true: # Если замедленное время включено
			Engine.time_scale = force # Устанавливаем значение движка на force, чтобы внутриигровые часы медленне тикали
		else: # Если замедленное время выключено:
			Engine.time_scale = 1 # Возвращаем стандартное значение внутриигровым часам


func _dead():
	var random_frame = randi_range(0, 4)
	is_dead = true
	animated_sprite_2d.animation = "death"
	animated_sprite_2d.frame = random_frame
	animated_sprite_2d.flip_h = true
	animated_sprite_2d.z_index = 0
	legs_anim.play("idle")
	emit_signal("player_is_dead")
