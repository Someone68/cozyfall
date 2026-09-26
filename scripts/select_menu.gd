extends VBoxContainer
class_name KeyMenu

signal item_selected(index: int, item: Control)

@export var normal_color := Color.WHITE
@export var highlight_color := Color(0.965, 0.82, 0.0, 1.0)
@export var wrap_around := true
@export var prefix := "> "
@export var spaces := "   "

var index := 0

func _ready():
	_refresh()

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
	_refresh()

func _refresh():
	var items := _items()
	for i in items.size():
		items[i].modulate = highlight_color if i == index else normal_color
		items[i].text = "> " + items[i].text.trim_prefix(spaces).trim_suffix(spaces) + spaces if i == index \
		else spaces + items[i].text.trim_prefix(prefix).trim_prefix(spaces).trim_suffix(spaces) + spaces
