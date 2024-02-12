extends Node

#var SAVE_GLOBAL_PATH = "res://global.dat"
var SAVE_GLOBAL_PATH = "res://save/profile0/global.dat"

#Player global
var player: Player
var enemy_death = 0

#Anim
var playing = false
#Save
var is_saving = false
var is_loading = false
var gamedata: Dictionary
var playerVec: Vector3

func _update_data():
	gamedata = {
		"player": {
			"position_x": playerVec.x,
			"position_y": playerVec.y
		}
	}

func saveGame():
	if is_saving:
		return
	
	_update_data()
	
	is_saving = true
	
	var file = FileAccess.open(SAVE_GLOBAL_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(gamedata.duplicate()))
	file.close()
	
	is_saving = false

func loadGame() -> bool:
	if is_loading:
		return false
	
	is_loading = true
	var file = FileAccess.file_exists(SAVE_GLOBAL_PATH)
	if not file:
		return false
	file = FileAccess.open(SAVE_GLOBAL_PATH, FileAccess.READ)
	gamedata = JSON.parse_string(file.get_as_text())
	file.close()
	
	playerVec.x = gamedata["player"]["position_x"]
	playerVec.y = gamedata["player"]["position_y"]
	is_loading = false
	return true

func _physics_process(_delta):
	pass
