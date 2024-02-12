extends Area2D
var hp = randi_range(10,20)

func _on_body_entered(body):
	if body is Player:
		if body.health < 200:
			body.health += hp
		queue_free()
