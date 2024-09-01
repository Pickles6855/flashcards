extends PanelContainer

signal popup_hide

@onready var main: TabContainer = find_parent("Menus")

@onready var tag_to_remove: OptionButton = $RemoveTagContainer/TagToRemove
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and visible:
		_hide()
		
	if Input.is_action_just_pressed("ui_accept") and visible and tag_to_remove.selected != -1:
		var tag_to_remove_name: String = tag_to_remove.get_item_text(tag_to_remove.selected)
		main.tags.erase(tag_to_remove_name)
		main.tags_updated.emit()
		_hide()
		

func _hide() -> void:
	visible = false
	popup_hide.emit()


func _show() -> void:
	size = Vector2.ZERO
	position = get_window().size / Vector2i(2, 2) - Vector2i(size / Vector2(2, 2))

	visible = true
	
	tag_to_remove.clear()
	
	for tag: String in main.tags:
		tag_to_remove.add_item(tag, main.tags.find(tag))
		
	tag_to_remove.selected = -1

	
