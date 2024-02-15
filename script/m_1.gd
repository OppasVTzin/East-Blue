extends VideoStreamPlayer
var packed:PackedScene = preload("res://Scenes/foosha_village.tscn")

func _on_finished():
	get_tree().change_scene_to_packed(packed)
