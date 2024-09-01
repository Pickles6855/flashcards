extends PopupPanel

signal popup_show

@onready var main: TabContainer = find_parent("Menus")

@onready var new_tag_name: LineEdit = $AddTagContainer/NewTagName


func _ready() -> void:
	popup_show.connect(_on_popup_show)
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and visible:
		hide()
		
	if Input.is_action_just_pressed("ui_accept") and visible and new_tag_name.text != "":
		main.tags.append(new_tag_name.text)
		main.tags_updated.emit()
		hide()
		

func _on_popup_show() -> void:
	new_tag_name.clear()
