extends VBoxContainer

signal custom_ready

const flashcard_set_btn_scene: PackedScene = preload("res://scenes/main_menu/flashcard_set_btn.tscn")
const flashcard_set_btn_group: ButtonGroup = preload("res://resources/flashcard_sets_btn_group.tres")

var sets_btn_group: ButtonGroup

@onready var sets_tab_container: TabContainer = $HBoxContainer/SelectSetPanel/SelectSet/SetsTabContainer
@onready var sets_container: VBoxContainer = $HBoxContainer/SelectSetPanel/SelectSet/SetsTabContainer/SetsScrollContainer/SetsContainer
@onready var select_tags: ItemList = $HBoxContainer/SelectSetPanel/SelectSet/SelectTags

@onready var main: TabContainer = get_parent()

func _ready() -> void:
	select_tags.select(0)
	await main.ready
	update_sets()
	update_tags()
	custom_ready.emit()
	
	main.tags_updated.connect(update_tags)
	main.sets_updated.connect(update_sets)
	
	
func _process(delta: float) -> void:
	if not select_tags.is_anything_selected():
		select_tags.select(0)
		
		
func load_set(flashcard_set: FlashcardsSet) -> void:
	var flashcard_set_btn: Button = flashcard_set_btn_scene.instantiate()
	flashcard_set_btn.text = flashcard_set.set_name
	flashcard_set_btn.button_group = flashcard_set_btn_group
	sets_container.add_child(flashcard_set_btn)
	
	sets_btn_group = flashcard_set_btn.button_group
	
	
func update_sets(index: int = -1) -> void:
	if index == -1:
		index = select_tags.get_selected_items()[0]
	
	var selected_tag: String = select_tags.get_item_text(index)
	
	for child in sets_container.get_children():
		sets_container.remove_child(child)
		child.queue_free()
	
	if selected_tag == "All":
		for flashcard_set: FlashcardsSet in main.sets:
			load_set(flashcard_set)
			
	else:
		for flashcard_set: FlashcardsSet in main.sets:
			if selected_tag in flashcard_set.tags:
				load_set(flashcard_set)
				
				
	if len(sets_container.get_children()) < 1:
		sets_tab_container.current_tab = 1
	else:
		sets_tab_container.current_tab = 0


func update_tags() -> void:
	select_tags.clear()
	select_tags.add_item("All")
	
	for tag: String in main.tags:
		select_tags.add_item(tag)
		
	for i in select_tags.item_count:
		select_tags.set_item_tooltip_enabled(i, false)
		
	select_tags.select(0)
