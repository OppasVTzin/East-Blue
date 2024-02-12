extends Area2D
class_name Hitbox
@onready var Shape = $Shape

func _physics_process(_delta):
	if Global.player.isAttacking:
		for body in get_overlapping_bodies():
			var enemy = body as Enemy_base
			if enemy:
				enemy.hurting = true
				enemy.health -= Global.player.attackAmount
				break
	#if Input.is_action_just_pressed("P_Ball"):
		#Shape.disabled = false
		#$Pistol.disabled = false
	#if Input.is_action_just_released("P_Ball"):
		#Shape.disabled = true
		#$Pistol.disabled = true
	#if Input.is_action_just_pressed("P_Trian"):
		#Shape.disabled = false
	#if Input.is_action_just_released("P_Trian"):
		#Shape.disabled = true
	#if Input.is_action_just_pressed("P_Cross"):
		#Shape.disabled = false
	#if Input.is_action_just_released("P_Cross"):
		#Shape.disabled = true
