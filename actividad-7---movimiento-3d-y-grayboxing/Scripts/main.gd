extends Node3D

var objetos_obtenidos := 0
@export var objetos_necesarios := 3

@onready var puerta = $Escenario/Puerta8

func sumar_objeto():
	objetos_obtenidos += 1
	
	print("OBJETOS OBTENIDOS: ", objetos_obtenidos, "/", objetos_necesarios)
	
	if objetos_obtenidos >= objetos_necesarios:
		abrir_puerta()

func abrir_puerta():
	print("¡PUERTA ABIERTA!")
	puerta.queue_free()
