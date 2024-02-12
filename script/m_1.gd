extends VideoStreamPlayer


func _on_finished():
	get_tree().change_scene_to_file("res://Scenes/foosha_village.tscn")
