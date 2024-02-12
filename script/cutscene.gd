extends VideoStreamPlayer

@onready var SceneMe = $"."
func _ready():
	Transition.get_node("Fill/Anim").play("fade_out")

func _process(_delta):
	if Input.is_action_just_pressed("Start"):
		goMap()
func _on_finished():
	goMap()

func goMap():
	paused = true
	Transition.get_node("Fill/Anim").play("fade_in")
	await Transition.get_node("Fill/Anim").animation_finished
	get_tree().change_scene_to_file("res://Scenes/OceanMap.tscn")
	Transition.get_node("Fill/Anim").play("fade_out")
