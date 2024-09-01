extends HBoxContainer

const edit_card_scene: PackedScene = preload("res://scenes/edit/edit_card.tscn")

var current_set: FlashcardsSet
var current_set_indx: int

@onready var main: TabContainer = get_parent()

@onready var add_tag_popup: PopupPanel = $Popups/AddTagPopup
@onready var remove_tag_popup: PanelContainer = $Popups/RemoveTagPopup

@onready var cards_container: VBoxContainer = $CardsPanel/VBoxContainer/CardsScrollContainer/CardsContainer

@onready var edit_set_name: LineEdit = $SetInfoPanel/SetInfoContainer/EditSetName
@onready var select_tags: ItemList = $SetInfoPanel/SetInfoContainer/SelectTags


func _ready() -> void:
	await main.ready
	update_available_tags()
	
	add_tag_popup.popup_hide.connect(update_available_tags)
	remove_tag_popup.popup_hide.connect(update_available_tags)
	

func update_available_tags() -> void:
	var selected_tags: PackedInt32Array = select_tags.get_selected_items()
	
	select_tags.clear()
	for tag: String in main.tags:
		select_tags.add_item(tag)
	
	for i in select_tags.item_count:
		#select_tags.set_item_tooltip_enabled(i, false)
		select_tags.set_item_tooltip(i, "Use Cmd/Ctrl Click to select multiple.")
		
		if i in selected_tags:
			select_tags.select(i, false)
			
	select_tags.select_mode = ItemList.SELECT_MULTI
		


func edit_set(flashcard_set: FlashcardsSet):
	current_set = flashcard_set
	current_set_indx = main.sets.find(current_set)
	
	# Remove old cards
	for child in cards_container.get_children():
		cards_container.remove_child(child)
		child.queue_free()
		
	# Add new cards
	for card: Flashcard in flashcard_set.set_cards:
		var edit_card_node: PanelContainer = edit_card_scene.instantiate()
		cards_container.add_child(edit_card_node)
		edit_card_node.front_text.text = card.card_front
		edit_card_node.back_text.text = card.card_back
		edit_card_node.card_indx = flashcard_set.set_cards.find(card)
	
	# Tags
	update_available_tags()
	
	select_tags.deselect_all()
	for tag: String in current_set.tags:
		var tag_indx = get_item_indx_from_text(select_tags, tag)
		if tag_indx == null:
			main.tags.append(tag)
			update_available_tags()
			tag_indx = get_item_indx_from_text(select_tags, tag)
			
		select_tags.select(tag_indx, false)


func get_item_indx_from_text(item_list: ItemList, text: String) -> Variant:
	for i in item_list.item_count:
		if item_list.get_item_text(i) == text:
			return i
	
	return null

	
func save_set() -> void:
	current_set.set_name = edit_set_name.text
	
	current_set.tags.clear()
	for tag_indx in select_tags.get_selected_items():
		current_set.tags.append(select_tags.get_item_text(tag_indx))
	
	current_set.set_cards.clear()
	
	for card_edit in cards_container.get_children():
		if card_edit.front_text.text != "" and card_edit.back_text.text != "":
			var card_obj: Flashcard = Flashcard.new()
			card_obj.card_front = card_edit.front_text.text
			card_obj.card_back = card_edit.back_text.text
			current_set.set_cards.append(card_obj)
	
	if current_set_indx == -1:
		main.sets.append(current_set)
	else:
		main.sets[current_set_indx] = current_set
		
	main.sets_updated.emit()


func _on_add_tag_btn_pressed() -> void:
	add_tag_popup.popup_show.emit()
	add_tag_popup.show()
	

func _on_remove_tag_btn_pressed() -> void:
	remove_tag_popup._show()
	

func _on_new_card_btn_pressed() -> void:
	var new_card: PanelContainer = edit_card_scene.instantiate()
	cards_container.add_child(new_card)


func _on_back_to_sets_btn_pressed() -> void:
	save_set()
	main.current_tab = 0


func _on_practice_set_btn_pressed() -> void:
	save_set()
