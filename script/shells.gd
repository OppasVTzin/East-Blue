class_name Shells extends Node2D
var completo = false

func _init(Boss:Morgan):
	if completo:
		SaveSystem._load()
	if Boss.health <= 0:
		completo = true
