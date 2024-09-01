extends Button

@onready var main: TabContainer = find_parent("Menus")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.double_click:
		button_pressed = false
		main.practice_set(main.get_set_by_name(text))
