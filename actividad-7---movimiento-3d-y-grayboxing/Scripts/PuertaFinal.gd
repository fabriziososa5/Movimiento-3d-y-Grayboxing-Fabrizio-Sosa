extends CSGBox3D

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Escenafinal.tscn")
