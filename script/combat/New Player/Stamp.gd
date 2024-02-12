extends PlayerAttack

func Attack():
	anim_sprite = anim_sprite as AnimatedSprite2D
	anim_sprite.play("Stamp")
	anim_sprite.frame = 0
	var player: Player = Global.player as Player		
	player.velocity.x = 0
	player.velocity.y = 0
	player.attackAmount = attackAmount
	while anim_sprite.frame <= triggerFrameEnd:
		player = Global.player as Player
		await anim_sprite.frame_changed
		if anim_sprite.frame >= triggerFrameStart and anim_sprite.frame < triggerFrameEnd:
			player.velocity.x += 0
			player.velocity.y += 0
	player.isAttacking = false
