class_name Morgan extends CharacterBody2D
var direction = -1
var state_machine
var health = 200
var speed = 10
var attack = false
var hurt = false
var target = 0
@onready var tempo = $Health
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	$Control/HealthBar.max_value = 200
func _physics_process(_delta):
	print(hurt)
	print(health)
	print(tempo.wait_time)
	$Control/HealthBar.value = health
	if hurt:
		state_machine.travel("Hurt")
		velocity.x = 0
	if health <= 0:
		queue_free()
	if $Ray_R.is_colliding():
		direction = -1
		$Sprite2D.flip_h = false
	elif $Ray_L.is_colliding():
		direction = 1
		$Sprite2D.flip_h = true
	velocity.x = direction * speed
	move_and_slide()
	for body in $Area2D.get_overlapping_bodies():
		var player = body as Player
		if player:
			if player.isAttacking:
				hurt = true
			attack = true
			target = global_position.direction_to(body.global_position)
func _on_area_2d_body_exited(body):
	if body is Player:
		state_machine.travel("Walk")


func _on_area_2d_body_entered(body):
	if body is Player:
		state_machine.travel("Attack")
		body.health -= 10


func _on_health_timeout():
	if hurt:
		state_machine.travel("Walk")
		health -= 20
	hurt = false
