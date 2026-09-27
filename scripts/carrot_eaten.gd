extends Control

@export var dialogues = ["the carrot was eaten.", "your life has been\nfullfilled.", "you think to yourself...", "i kinda want another\ncarrot."]
var i = 0

func _ready() -> void:
	$Timer.start()
	$Label.text = dialogues[0]


func _on_timer_timeout() -> void:
	i += 1
	if (i >= len(dialogues)):
		get_tree().paused = false
		Gamemgr.go_to_credits()
		return
	$Beep.play()
	$Label.text = dialogues[i]
