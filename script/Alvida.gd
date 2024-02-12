extends CharacterBody2D
class_name Enemy_Base

var health = 800

func Health():
	health -= 10
	if health <= 0:
		$Anim.play("Death")
		await $Anim.animation_finished
		queue_free()
	if is_queued_for_deletion():
		get_tree().change_scene_to_file("res://Scenes/OceanMap.tscn")
