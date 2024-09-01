extends PanelContainer

@onready var flip_card_btn: Button = $CardVBox/FlipCardBtn

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_released():
		flip_card_btn.pressed.emit()
