extends CPUParticles2D


func _ready():
	self.emitting = true

func _on_timer_timeout():
	queue_free()
