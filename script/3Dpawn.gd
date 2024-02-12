extends CharacterBody3D
class_name Merry
var direction : Vector3 = Vector3.ZERO;
var rotate : float = 0.0;
var run : float = 2.5
@onready var ocean = $"../Ocean"
@export var float_force := 1.0

func _physics_process(_delta):
	Global.playerVec = position
func Move_cam():
	if Input.is_action_pressed("R2"):
		$Camera3D.position.z -= 0.1
	if Input.is_action_pressed("L2"):
		$Camera3D.position.z += 0.1
	if Input.is_action_pressed("5"):
		$Camera3D.position.x -= 0.1
		$Camera3D.position.y -= 0.1
	if  Input.is_action_pressed("L3"):
		$Camera3D.position.x += 0.1
		$Camera3D.position.y += 0.1
	if Input.is_action_just_pressed("Oi"):
		$Camera3D.position.x = -5
		$Camera3D.rotation_degrees.y = -90
	if Input.is_action_just_released("Oi"):
		$Camera3D.rotation_degrees.y = 90
		$Camera3D.position.x = 5
		$Camera3D.position.y = 5
		$Camera3D.position.z = 0
		$Camera3D.rotation_degrees.x = -25
		$Camera3D.rotation_degrees.z = 0
	if  Input.is_action_pressed("Oi"):
		$Camera3D.position.x = -5
		$Camera3D.rotation_degrees.y = -90
func inputMove():
	direction = Vector3.ZERO;
	rotate = 0.0;
	run = 2.5
	if Input.is_action_pressed("S"):
		$Camera3D.position.x = -5
		$Camera3D.rotation_degrees.y = -90
		direction.x += 1
	if Input.is_action_just_released("S"):
		$Camera3D.position.x = 5
		$Camera3D.rotation_degrees.y = 90
	if Input.is_action_pressed("W"):
		direction.x -= run
	if Input.is_action_pressed("A"):
		rotation.y += 0.1
	if Input.is_action_pressed("D"):
		rotation.y -= 0.1
	if direction != Vector3.ZERO:
		direction = direction.normalized();


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	inputMove()
	Move_cam()
	# get the forward and right directions
	var forward = global_transform.basis.z;
	var right = global_transform.basis.x;
	
	# Adjust movement direction by rotation transform
	var relativeDir = (forward * direction.z + right * direction.x);
	
	self.position += Vector3.ZERO.slerp(relativeDir * run, 0.65)
	self.rotation.y +=  lerp_angle(0, rotate * 0.1, 0.25)
	ocean.position = self.position - Vector3(0.0,0.9,0.0)

func _on_area_3d_body_entered(_body):
	var anim = Transition.get_node("Fill/Anim") as AnimationPlayer
	anim.play("fade_in")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://Scenes/m_1.tscn")
	anim.play("fade_out")


func _on_body_entered(_body):
	var anim = Transition.get_node("Fill/Anim") as AnimationPlayer
	anim.play("fade_in")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Shells_cut.tscn")
	anim.play("fade_out")
