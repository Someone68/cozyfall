extends VBoxContainer
class_name KeyMenu

signal item_selected(index: int, item: Control)

@export var normal_color := Color.WHITE
@export var highlight_color := Color(0.965, 0.82, 0.0, 1.0)
@export var wrap_around := true
@export var prefix := "> "
@export var alternate_add := " "
@export var spaces := "   "

var index := 0
var alternate_prefix := false

func _ready():
	refresh()

func _items() -> Array:
	return get_children().filter(func(c): return c is Control and c.visible)

func _unhandled_input(event):
	if not is_visible_in_tree():
		return
	var items := _items()
	if items.is_empty():
		return
	if event.is_action_pressed("ui_down"):
		_move(1, items.size())
	elif event.is_action_pressed("ui_up"):
		_move(-1, items.size())
	elif event.is_action_pressed("ui_accept"):
		item_selected.emit(index, items[index])
	else:
		return
	if (get_viewport()):
		get_viewport().set_input_as_handled()

func _move(dir: int, count: int):
	index = wrapi(index + dir, 0, count) if wrap_around else clampi(index + dir, 0, count - 1)
	refresh()

func refresh():
	$Timer.start(0.3)
	$Timer.set_wait_time(1)
	alternate_prefix = false
	var items := _items()
	for i in items.size():
		items[i].modulate = highlight_color if i == index else normal_color
		items[i].text = alternate_add + prefix + remove_prefix(items[i].text) + spaces + alternate_add if i == index \
		else spaces + alternate_add + remove_prefix(items[i].text) + spaces + alternate_add

func _on_timer_timeout() -> void:
	var items := _items()
	items[index].text = alternate_add + prefix + remove_prefix(items[index].text) + spaces + alternate_add if alternate_prefix \
	else prefix + alternate_add + remove_prefix(items[index].text) + spaces + alternate_add
	alternate_prefix = !alternate_prefix

func remove_prefix(text: String) -> String:
	return text.trim_prefix(alternate_add).trim_prefix(prefix).trim_prefix(spaces).trim_prefix(alternate_add).trim_suffix(spaces).trim_suffix(alternate_add)
