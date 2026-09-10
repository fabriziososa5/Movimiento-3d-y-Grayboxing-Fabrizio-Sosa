extends CharacterBody3D

@export var velocidad := 5.0
@export var gravedad := 20.0
@export var sensibilidad := 0.002

@export var fuerza_salto := 7.0
@export var velocidad_agachado := 3.0

@onready var camara = $Camera3D
@onready var colision = $CollisionShape3D

var agachado := false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensibilidad)

		camara.rotate_x(-event.relative.y * sensibilidad)

		camara.rotation.x = clamp(camara.rotation.x,deg_to_rad(-80),deg_to_rad(80))


func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravedad * delta


	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = fuerza_salto


	if Input.is_action_pressed("agacharse"):
		agachado = true
	else:
		agachado = false



	var input = Input.get_vector("izquierda","derecha","adelante","atras")

	var direccion = (transform.basis * Vector3(input.x, 0, input.y)).normalized()

	var velocidad_actual = velocidad

	if agachado:
		velocidad_actual = velocidad_agachado

	velocity.x = direccion.x * velocidad_actual
	velocity.z = direccion.z * velocidad_actual


	move_and_slide()
