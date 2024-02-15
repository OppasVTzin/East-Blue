extends VideoStreamPlayer
var packed:PackedScene = load("res://Scenes/loading.tscn")
@onready var SceneMe = $"."
func _ready():
	Transition.get_node("Fill/Anim").play("fade_out")

func _process(_delta):
	if Input.is_action_just_pressed("Start"):
		enter()
func _on_finished():
	enter()

func enter():
	get_tree().change_scene_to_packed(packed)
