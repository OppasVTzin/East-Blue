class_name PlayerAttack extends Node

@export_node_path("AnimatedSprite2D") var anim_sprite
@export var attackAmount: float = 0.0
@export var triggerFrameStart = 0
@export var triggerFrameEnd = 0
var isCurrentAttack: bool = false

func _ready():
	self.anim_sprite = get_node(anim_sprite) as AnimatedSprite2D

func attack():
	#is this attack the current selected?
	if not isCurrentAttack:
		return
