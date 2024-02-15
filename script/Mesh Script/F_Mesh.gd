extends ObjetivoMesh

func _ready():
	$".".mesh = null
	if level_load.completo:
		$".".mesh = Mesh_load

