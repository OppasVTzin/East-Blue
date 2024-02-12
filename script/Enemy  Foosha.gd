class_name Enemy_base extends CharacterBody2D
var health = 100 : set = _on_health_set
var direction = 1
var speed = randi_range(8, 16)
var gravity = 1000
@onready var PL = $"../Player"
@export var packed:PackedScene
@onready var knifeScene = preload("res://Scenes/prefab/thrownKnife.tscn")
@export var maxKnivesSpawn = 3

var attacking = false
var hurting = false
var targetDirection = 0

func drop_item():
	var hp = packed.instantiate()
	hp.global_position = global_position
	get_parent().add_child(hp)

func _ready():
	$HealthBar.max_value = health
	#$HealthBar.hide()

#override function of self.health
func _on_health_set(value):
	if not $HitboxTimeout.time_left:
		health = value
		$ShowHealthTimeout.start()
		$HitboxTimeout.start()
		$HealthBar.value = health
		$HealthBar.show()
		$AnimationPlayer.play("hit")

func _physics_process(delta):
	if health <= 0:
		Global.enemy_death += 1
		queue_free()
		drop_item()
	if hurting: #Getting Damage
		velocity.x = 0
		$Sprite2.play("hit")
		hurting = false
		return
	
	#Player spotter
	for body in $PlayerSpotter.get_overlapping_bodies():
		var player = body as Player
		if player:
			if player.isAttacking:
				return
			attacking = true
			targetDirection = global_position.direction_to(body.global_position)
	
	if not attacking: #Move
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if not $Ray_D.is_colliding() and is_on_floor():
			$Sprite2.flip_h = !$Sprite2.flip_h
			direction *= -1
		if $Ray_R.is_colliding():
			direction = -1
		elif $Ray_L.is_colliding():
			direction = 1
		
		if velocity.x != 0: #moving
			$Sprite2.play("walk")
		else:
			$Sprite2.play("idle")
		
		$Sprite2.flip_h = direction > 0
		velocity.x = direction * speed
		move_and_slide()
	
	if $HitboxTimeout.time_left: #Still dealing damage/hurt
		return
	if attacking and not $AttackTimer.time_left: #Attacking
		$Sprite2.flip_h = targetDirection.x > 0
		$Sprite2.play("attack")
		await $Sprite2.animation_finished
		$AttackTimer.start()
		
		if $KnivesSpawn.get_child_count() < maxKnivesSpawn and attacking: #Spawn knives
			var knife = knifeScene.instantiate() as Area2D
			knife.direction = 1 if targetDirection.x > 0 else -1
			$KnivesSpawn.add_child(knife)
		attacking = false

func _on_show_health_timeout_timeout():
	$HealthBar.hide()
