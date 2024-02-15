extends ObjetivoMesh

func _ready():
	$".".mesh = Mesh_load
	if level_load.completo:
		$".".mesh = null

