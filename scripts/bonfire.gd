extends FloorEntity

func on_enter(player: Node2D):
	player.temperature = player.MAX_TEMPERATURE
	print("bonfire")
