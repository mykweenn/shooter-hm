extends Camera2D

var shake_amount : float = 0
@onready var timer : Timer = $Timer
@onready var tween : Tween = create_tween()

const MAX_DISTANCE := 80

var target_distance = 0
var center_pos = position

func _ready():
	set_process(true)
	randomize()

func cameraUpdate():
	var direction = center_pos.direction_to(get_local_mouse_position())
	var target_pos = center_pos + direction * target_distance
	
	target_pos = target_pos.clamp(
		center_pos - Vector2(MAX_DISTANCE, MAX_DISTANCE),
		center_pos + Vector2(MAX_DISTANCE, MAX_DISTANCE)
	)
	
	position = target_pos

func _input(event):
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 2

func _process(_delta: float):
	offset = Vector2(randf_range(-3, 3) * shake_amount, randf_range(-3, 3) * shake_amount)
	cameraUpdate()

func shake(time: float, amount: float):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()


func _on_timer_timeout():
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
