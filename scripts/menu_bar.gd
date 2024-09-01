extends MenuBar

@onready var main: TabContainer = $"../MarginContainer/Menus"

@onready var file_popup_menu: PopupMenu = $File

func _ready() -> void:
	setup_file_menu()


func setup_file_menu() -> void:
	file_popup_menu.add_shortcut(load("res://resources/shortcuts/new_set_shortcut.tres"), 0)
	file_popup_menu.set_item_text(0, "New Set")
	
	file_popup_menu.add_shortcut(load("res://resources/shortcuts/open_set_shortcut.tres"), 1)
	file_popup_menu.set_item_text(1, "Back to Sets")
	
	file_popup_menu.add_separator("", 2)
	
	file_popup_menu.add_item("Add Tag", 3)
	file_popup_menu.add_item("Remove Tag", 4)
	
	file_popup_menu.add_separator("", 5)
	
	file_popup_menu.add_shortcut(load("res://resources/shortcuts/close_window.tres"), 6)
	file_popup_menu.set_item_text(6, "Close")
	
	file_popup_menu.id_pressed.connect(_on_file_menu_id_pressed)
	
	
func _on_file_menu_id_pressed(id: int) -> void:
	match id:
		# New Set
		0:
			main.edit_set()
			
		# Open Set	
		1:
			if main.current_tab == 1:
				main.edit_set_tab._on_back_to_sets_btn_pressed()
			elif main.current_tab == 2:
				main.current_tab = 0
		
		# Add Tag
		3:
			main.edit_set_tab._on_add_tag_btn_pressed()
			
		# Remove Tag
		4:
			main.edit_set_tab._on_remove_tag_btn_pressed()
			
		# Close
		6:
			get_tree().quit()
