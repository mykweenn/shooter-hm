extends Node2D


@onready var ui_game_over = $UIGameOver




func spawn_zombie():
	var new_zombie = preload("res://Scenes/enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_zombie.global_position = %PathFollow2D.global_position
	add_child(new_zombie)


func _on_timer_timeout():
	spawn_zombie()



func _on_player_player_is_dead():
	ui_game_over.visible = true
