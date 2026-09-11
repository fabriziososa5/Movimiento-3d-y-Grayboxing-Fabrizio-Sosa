extends CharacterBody3D

@export var velocidad := 4.0
@export var gravedad := 20.0
@export var sensibilidad := 0.002
@export var velocidad_agachado := 1.5
@export var velocidad_correr := 6.5
@export var fuerza_salto := 7.0
@export var altura_normal := 1.8
@export var altura_agachado := 1.1
@export var altura_camara_normal := 0.7
@export var altura_camara_agachado := 0.5
@export var balanceo_correr := 0.05
@export var velocidad_balanceo := 10.0

var tiempo_balanceo := 0.0
var posicion_camara_original := Vector3.ZERO
var en_escalera := false
var escalera_actual: Node3D = null
var agarrado_borde := false
var borde_actual: Node3D = null
var puede_agarrarse := true

@onready var camara = $RayCast3D/Camera3D
@onready var colision = $CollisionShape3D

var agachado := false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	posicion_camara_original = camara.position


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


func cambiar_agachado(valor: bool):
	agachado = valor
	
	var capsule = colision.shape as CapsuleShape3D
	
	if agachado:
		capsule.height = altura_agachado
		camara.position.y = altura_camara_agachado
	else:
		capsule.height = altura_normal
		camara.position.y = altura_camara_normal

func mover_escalera(delta):
	velocity.x = 0
	velocity.z = 0
	velocity.y = 0

	if Input.is_action_pressed("adelante"):
		velocity.y = 2.0

	elif Input.is_action_pressed("atras"):
		velocity.y = -2.0

	move_and_slide()
	
func subir_borde():
	if borde_actual == null:
		return

	var posicion_subida = borde_actual.get_node("PuntoSubida")

	global_position = posicion_subida.global_position

	velocity = Vector3.ZERO

	agarrado_borde = false
	puede_agarrarse = false
	borde_actual = null

	print("SUBIENDO BORDE")

func _physics_process(delta):

	if en_escalera:
		mover_escalera(delta)
		return
		
	if agarrado_borde:
		velocity = Vector3.ZERO

		if Input.is_action_just_pressed("saltar"):
			subir_borde()

		return

	if not is_on_floor():
		velocity.y -= gravedad * delta

	if Input.is_action_just_pressed("saltar"):

		if is_on_floor():
			velocity.y = fuerza_salto

	if Input.is_action_just_pressed("saltar"):

		if agarrado_borde:
			subir_borde()
			return

		if is_on_floor():
			velocity.y = fuerza_salto


	if Input.is_action_just_pressed("agacharse"):
		cambiar_agachado(!agachado)


	var input = Input.get_vector("izquierda", "derecha", "adelante", "atras")

	var direccion = (transform.basis * Vector3(input.x, 0, input.y)).normalized()

	var velocidad_actual = velocidad

	var corriendo = Input.is_action_pressed("correr") and input.y < 0 and not agachado

	if agachado:
		velocidad_actual = velocidad_agachado
	elif corriendo:
		velocidad_actual = velocidad_correr

	if corriendo and is_on_floor():
		tiempo_balanceo += delta * velocidad_balanceo
		camara.position.y = posicion_camara_original.y + sin(tiempo_balanceo) * balanceo_correr
		camara.position.x = posicion_camara_original.x + cos(tiempo_balanceo * 0.5) * balanceo_correr * 0.5

	else:
		tiempo_balanceo = 0.0
		camara.position.y = lerp(camara.position.y,posicion_camara_original.y,delta * 10.0)

		camara.position.x = lerp(camara.position.x,posicion_camara_original.x,delta * 10.0)

	velocity.x = direccion.x * velocidad_actual
	velocity.z = direccion.z * velocidad_actual

	move_and_slide()
	
