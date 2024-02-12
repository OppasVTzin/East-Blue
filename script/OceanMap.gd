extends Node3D
@onready var Merry_position = $Merry.global_position

func _init(Island1:Foosha,Island2:Shells):
	if Island1.completo:
		SaveSystem.save()
	if  Island2.completo:
		SaveSystem.save()
