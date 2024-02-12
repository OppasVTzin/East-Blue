extends Control

@export_flags ("Pixels", "Spot Player","Spot Center","Vertical Cut", "Horizontal Cut") var transition_type
@export var duration:float = 1.0

func _ready():
	Transition.get_node("Fill/Anim").speed_scale = duration

func _physics_process(_delta):
	if Input.is_action_just_pressed("Start") and not Transition.get_node("Fill/Anim").is_playing():
		Transition.get_node("Fill/Anim").play("fade_in")
		await Transition.get_node("Fill/Anim").animation_finished
		get_tree().change_scene_to_file("res://Scenes/cutscene.tscn")
