extends TabContainer

var sets_btn_group: ButtonGroup
var selected_set: FlashcardsSet

@onready var main: TabContainer = find_parent("Menus")
@onready var main_menu: VBoxContainer = find_parent("MainMenu")

@onready var set_name: Label = $SelectedSetInfo/SetName
@onready var set_card_count: Label = $SelectedSetInfo/SetCardCount
@onready var set_last_played: Label = $SelectedSetInfo/SetLastPlayed

func _ready() -> void:
	await main_menu.custom_ready
	sets_btn_group = main_menu.sets_btn_group
	

func _process(delta: float) -> void:
	var selected_set_btn
	if sets_btn_group != null:
		selected_set_btn = sets_btn_group.get_pressed_button()
	else:
		selected_set_btn = null
		
	if selected_set_btn == null:
		current_tab = 1
		selected_set = null
	else:
		current_tab = 0
		
		selected_set = main.get_set_by_name(selected_set_btn.text)
		
		if selected_set != null:
			set_name.text = selected_set.set_name
			set_card_count.text = "%s Cards" % str(len(selected_set.set_cards))
			
			if selected_set.last_played.has_all(["year", "month", "day"]):
				set_last_played.text = "%s/%s/%s" % [
					selected_set.last_played["month"],
					selected_set.last_played["day"],
					selected_set.last_played["year"],
				]
			else:
				set_last_played.text = "N/A"
			


func _on_practice_set_btn_pressed() -> void:
	main.practice_set(selected_set)
	
	
func _on_edit_set_btn_pressed() -> void:
	main.edit_set(selected_set)


func _on_delete_set_btn_pressed() -> void:
	pass
	

func _on_new_set_btn_pressed() -> void:
	main.edit_set()
