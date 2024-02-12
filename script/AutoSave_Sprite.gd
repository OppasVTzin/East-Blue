extends AnimatedSprite2D
func _ready():
	Global.playing = true



func _on_animation_finished():
	queue_free()
