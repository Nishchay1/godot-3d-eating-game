extends Spatial

onready var particles = $CPUParticles

func _ready():
	particles.emitting=true

func _process(delta):
	if !particles.emitting:
		queue_free()
