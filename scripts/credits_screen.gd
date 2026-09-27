extends Control

const titles := ["DESIGN", "PROGRAMMING", "UI/LEVEL DESIGN", "ART", "MUSIC & SFX", "THANK YOU"]
const names := ["potato, .rbird_", "potato, itstntcraft", "itstntcraft", ".rbird_, bacon", "bacon", "for playing <3"]
var i = 0

func _ready() -> void:
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
	Gamemgr.back_to_menu()
