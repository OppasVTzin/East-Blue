class_name Foosha extends Node2D
var completo = false
var packed:PackedScene = preload("res://Scenes/OceanMap.tscn")
func _process(_delta):
	print(completo)
	if completo:
		completo = true
		get_tree().change_scene_to_packed(packed)
	elif Global.enemy_death == 5:
		completo = true
