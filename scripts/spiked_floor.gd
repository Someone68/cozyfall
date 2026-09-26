extends FloorEntity

func on_enter(player: Node2D):
	player.die(true)
