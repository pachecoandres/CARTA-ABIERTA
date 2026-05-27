extends GPUParticles2D

func _ready():
	emitting = false
	await get_tree().create_timer(1.0).timeout
	emitting = true
