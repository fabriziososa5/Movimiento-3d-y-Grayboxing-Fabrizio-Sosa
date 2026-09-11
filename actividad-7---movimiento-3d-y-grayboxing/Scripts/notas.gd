extends CSGBox3D

var jugador_cerca := false
var jugador = null

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		jugador_cerca = true
		jugador = body
		jugador.mostrar_mensaje()


func _on_area_3d_body_exited(body):
	if body == jugador:
		jugador_cerca = false
		jugador.ocultar_mensaje()
		jugador = null


func _process(_delta):
	if jugador_cerca and Input.is_action_just_pressed("usar"):
		get_tree().current_scene.sumar_objeto()
		queue_free()
