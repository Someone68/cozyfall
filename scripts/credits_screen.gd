extends Control

var is_child := false
const titles := ["DESIGN", "PROGRAMMING", "UI/LEVEL DESIGN", "ART", "MUSIC & SFX", "THANK YOU"]
const names := ["potato, rbird._", "potato, itstntcraft", "itstntcraft", "rbird._, bacon", "bacon", "for playing <3"]
var i = 0

func _ready() -> void:
	if Settings.music:
		$CreditsMusic.play()
	$NameTimer.start()
	$MarginContainer/VBoxContainer/Label.text = titles[i]
	$MarginContainer/VBoxContainer/Label2.text = names[i]

func _on_name_timer_timeout() -> void:
	print("timeout")
	i += 1
	if (i > len(titles)-1):
		$SelectMenu.visible = true
		return
	$MarginContainer/VBoxContainer/Label.text = titles[i]
	$MarginContainer/VBoxContainer/Label2.text = names[i]

func _on_select_menu_item_selected(index: int, item: Control) -> void:
	if is_child:
		get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
		queue_free()
	else:
		Gamemgr.back_to_menu()
