class_name Player extends CharacterBody2D



#Player Stats
var health = 200
var movementDirection = 1

#MovementStats
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#AttackStats
const LOW_DAMAGE_ATTACK = 10
const MEDIUM_DAMAGE_ATTACK = 15
const CRITICAL_DAMAGE_ATTACK = 30

var gravity = 1000
var attackAmount = 0
var current_attack = null
var isAttacking = false

func _ready():
	if  Global.player == null:
		Global.player = self #self -> this class, this player
	$hud/Status/HealthBar.max_value = health

#func _process(_delta):
	#damage enemy
	#var body = $AreaAttack.get_overlapping_bodies()
	#if body.is_empty():
		#return
	#body = body[0]
	#if body is Enemy_base:
		##await $Anim.animation_finished
		#body.health -= LOW_DAMAGE_ATTACK

func _physics_process(delta):

	# @VT Attack scripts
	#Ataques
	#if Input.is_action_pressed("P_Cross"):
		#$Anim.play("Bazooka")
		#await $Anim.animation_finished
	#elif  Input.is_action_pressed("P_Trian"):
		#$Anim.play("Axe")
		#await $Anim.animation_finished
	#elif Input.is_action_pressed("P_Ball"):
		#$Anim.play("Pistol")
		#await $Anim.animation_finished
	
	# @Gbmanki Attack scripts
	#Attacks
	if Input.is_action_just_pressed("P_Cross"):
		isAttacking = true
		$Attacks/Fuusen.Attack()
	elif Input.is_action_just_pressed("P_Ball"):
		isAttacking = true
		$Attacks/Gatling.Attack()
	elif  Input.is_action_just_pressed("P_Quad"):
		isAttacking = true
		$Attacks/Tackle.Attack()
	elif Input.is_action_just_pressed("P_Trian"):
		isAttacking = true
		$Attacks/Bazooka.Attack()
	var stop = Vector2(Input.get_axis("A","S"), Input.is_action_just_pressed("W"))
	if stop:
		isAttacking = false
	if not isAttacking:
		_move(delta)
	move_and_slide()
	
	#Status
	$hud/Status/HealthBar.value = health
	if health <= 0:
		get_tree().reload_current_scene() #reload cause theres no MENU or UI to handle it.

func _move(delta):
	#Physics
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("W") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Texture.play("Jump")
	#Inputs
	var direction = Input.get_axis("A", "D")
	
	if direction:
		movementDirection = direction
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
	
	if direction == 0:
		$Texture.play("Idle")
	else:
		$Texture.play("Walk")
	
	if direction > 0:
		$Texture.flip_h = false
	elif direction < 0:
		$Texture.flip_h = true
	if Input.is_action_pressed("Dash") and direction:
		$Texture.play("Dash")
		velocity.x = SPEED * 30
