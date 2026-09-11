extends SpotLight3D

@export var energia_normal := 1.0
@export var intervalo_min := 0.05
@export var intervalo_max := 0.3

var tiempo := 0.0

func _ready():
	light_energy = energia_normal


func _process(delta):
	tiempo -= delta

	if tiempo <= 0:
		tiempo = randf_range(intervalo_min, intervalo_max)

		# Titileo aleatorio
		if randf() < 0.5:
			light_energy = randf_range(0.1, energia_normal)
		else:
			light_energy = energia_normal
