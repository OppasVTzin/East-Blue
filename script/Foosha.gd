class_name Foosha extends Node2D
var completo = false

func _process(_delta):
	if completo:
		get_tree().change_scene_to_file("res://Scenes/OceanMap.tscn")
	elif Global.enemy_death >= 5:
		completo = true
