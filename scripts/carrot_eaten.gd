extends Control

@export var dialogues = ["the carrot was eaten.", "your life has been\nfullfilled.", "you think to yourself...", "i kinda want another\ncarrot."]
var i = 0

func _ready() -> void:
	$Label.text = dialogues[0]

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_accept")):
		i += 1
		if (i >= len(dialogues)):
			Gamemgr.back_to_menu()
			return
		$Beep.play()
		$Label.text = dialogues[i]
