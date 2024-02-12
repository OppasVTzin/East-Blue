extends Label

func _physics_process(_delta):
	text = str("FPS: ", Engine.get_frames_per_second())
