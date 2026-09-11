extends Node3D

@onready var area = $Escalera/Area3D
@onready var inicio = $Escalera/Inicio
@onready var fin = $Escalera/Final
@onready var area2 = $BloqueTrepar/Area3D

var jugador_cerca := false
var jugador = null
var jugador_borde = null


func _process(_delta):
	if Input.is_action_just_pressed("usar"):
		if jugador_cerca and jugador != null:
			jugador.en_escalera = true
			jugador.escalera_actual = self
			print("ESCALERA ACTIVADA")

	if jugador != null and jugador.en_escalera:


		if jugador.global_position.y >= fin.global_position.y:
			jugador.en_escalera = false
			jugador.escalera_actual = null
			print("ESCALERA TERMINADA ARRIBA")

		elif jugador.global_position.y <= inicio.global_position.y + 0.15:
			jugador.global_position.y = inicio.global_position.y
			jugador.en_escalera = false
			jugador.escalera_actual = null
			print("ESCALERA TERMINADA ABAJO")
			
			
	if jugador_borde != null:
		if not jugador_borde.is_on_floor() and jugador_borde.puede_agarrarse:
			jugador_borde.agarrado_borde = true
			jugador_borde.borde_actual = $BloqueTrepar

func _on_body_entered(body):
	if body is CharacterBody3D:
		jugador_cerca = true
		jugador = body
		print("Jugador cerca de la escalera")


func _on_body_exited(body):
	if body is CharacterBody3D:
		jugador_cerca = false
		print("Jugador salió de la escalera")
		
		

func _on_body_area_2_entered(body):
	if body is CharacterBody3D:
		jugador_borde = body
		print("JUGADOR EN AREA DEL BORDE")


func _on_body_area_2_exited(body):
	if body == jugador_borde:
		jugador_borde.puede_agarrarse = true
		jugador_borde = null
