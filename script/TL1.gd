extends Area3D

func _on_area_entered(area):
	if area is Merry:
		get_tree().change_scene_to_file("res://Scenes/foosha_village.tscn")
