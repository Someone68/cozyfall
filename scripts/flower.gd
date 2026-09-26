extends FloorEntity

func on_enter(player: Node2D):
	level.level_complete()
