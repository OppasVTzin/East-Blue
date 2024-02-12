extends Area2D

var sfx_spawn = preload("res://Assets/sound/sfx/knifeThrown.wav")
var sfx_quit = preload("res://Assets/sound/sfx/woodenBoxBreaking.wav")

var active = true
@export var mass = 0.003
@export var thrownSpeed = randi_range(2, 3)
var direction = 0

func _ready():
	$Sprite2D.play("idle")
	$AudioStreamPlayer2D.stream = sfx_spawn
	$AudioStreamPlayer2D.play()

func _physics_process(delta):
	if not active:
		#destroy =>
		if $AudioStreamPlayer2D.stream != sfx_quit:
			$AudioStreamPlayer2D.stream = sfx_quit
			$AudioStreamPlayer2D.play()
		$Sprite2D.play("boom")
		await $Sprite2D.animation_finished
		queue_free()
		return
	if not is_queued_for_deletion():
		#move =>
		position.y += float(mass * gravity * delta)
		position.x += direction * thrownSpeed
		$Sprite2D.flip_h = false if direction > 0 else true
		for overlap in get_overlapping_bodies():
			var isPlayer = overlap as Player
			if isPlayer != null:
				if isPlayer.isAttacking:
					return
				overlap.health -= 20
				active = false
			elif overlap and isPlayer == null: #Exists but is not player
				active = false
				return
