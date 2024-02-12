extends MeshInstance3D

var direction : Vector3 = Vector3.ZERO;
var rotate : float = 0.0;
var speed : float = 0.2;

@onready var ocean = $"../Ocean"

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
	speed = 0.2;
	if Input.is_action_pressed("S"):
		direction.x += 1;
	if Input.is_action_pressed("W"):
		direction.x -= 1;
	if Input.is_action_pressed("A"):
		direction.z += 1;
	if Input.is_action_pressed("D"):
		direction.z -= 1;
	if direction != Vector3.ZERO:
		direction = direction.normalized();
	if Input.is_action_pressed("R3"):
		rotate = -1.0;
	if Input.is_action_pressed("R4"):
		rotate = 1.0;
	if Input.is_action_pressed("Speed"):
		speed = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_sdelta):
	inputMove();
	Move_cam()
	# get the forward and right directions
	var forward = global_transform.basis.z;
	var right = global_transform.basis.x;
	
	# Adjust movement direction by rotation transform
	var relativeDir = (forward * direction.z + right * direction.x);
	
	self.position += relativeDir * speed;
	self.rotation.y += rotate * 0.1;
	ocean.position = self.position - Vector3(0.0,1.0,0.0);
