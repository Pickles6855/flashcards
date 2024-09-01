extends TabContainer

signal tags_updated
signal sets_updated

var tags: Array[String]
var sets: Array[FlashcardsSet]

@onready var main_menu_tab: VBoxContainer = $MainMenu
@onready var edit_set_tab: HBoxContainer = $EditSet
@onready var practice_set_tab: TabContainer = $PracticeSet

func _ready() -> void:
	load_saved_data()
	load_flashcard_sets()
	
	tags_updated.connect(save_data)
	sets_updated.connect(save_flashcard_sets)
	

func load_saved_data() -> void:
	var saved_data: SavedData = ResourceLoader.load("user://saved_data.tres") as SavedData
	
	if saved_data == null:
		saved_data = SavedData.new()
		
	tags = saved_data.tags
	

func load_flashcard_sets() -> void:
	var flashcard_set_names: PackedStringArray = DirAccess.get_files_at("user://sets")
	for set_name: String in flashcard_set_names:
		var flashcard_set: FlashcardsSet = ResourceLoader.load("user://sets/%s" % set_name)
		sets.append(flashcard_set)


func get_set_by_name(set_name: String) -> FlashcardsSet:
	for flashcard_set: FlashcardsSet in sets:
		if flashcard_set.set_name == set_name:
			return flashcard_set
	
	return null


func save_all() -> void:
	save_flashcard_sets()
	save_data()
	

func save_flashcard_sets() -> void:
	for flashcard_set: FlashcardsSet in sets:
		ResourceSaver.save(flashcard_set, "user://sets/%s.tres" % flashcard_set.set_name.to_snake_case())
	

func save_data() -> void:
	var saved_data: SavedData = SavedData.new()
	saved_data.tags = tags
	
	ResourceSaver.save(saved_data, "user://saved_data.tres")
	

func edit_set(flashcard_set: FlashcardsSet = FlashcardsSet.new()) -> void:
	edit_set_tab.edit_set(flashcard_set)
	current_tab = 1
	
	
func practice_set(flashcard_set: FlashcardsSet) -> void:
	practice_set_tab.practice_set(flashcard_set)
	current_tab = 2
