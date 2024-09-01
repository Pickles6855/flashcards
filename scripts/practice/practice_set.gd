extends TabContainer

var current_set: FlashcardsSet
var current_card: int = 0
var num_of_cards: int
var card_side: int = 0

var right: int = 0

var finished_cards: Array[int] = []

@onready var main: TabContainer = get_parent()

@onready var set_name: Label = $PracticeSet/SetName
@onready var practice_progress: Label = $PracticeSet/ProgressContainer/PracticeProgress
@onready var card_front: Label = $PracticeSet/CardPanelContainer/CardVBox/CardSideTabs/CardFront
@onready var card_back: Label = $PracticeSet/CardPanelContainer/CardVBox/CardSideTabs/CardBack
@onready var card_side_tabs: TabContainer = $PracticeSet/CardPanelContainer/CardVBox/CardSideTabs

@onready var finished_set_name: Label = $FinishedSet/SetName
@onready var right_percent: Label = $FinishedSet/RightPercent
@onready var right_number: Label = $FinishedSet/RightNumber

func practice_set(flashcard_set: FlashcardsSet) -> void:
	current_tab = 0
	
	current_set = flashcard_set
	current_card = 0
	num_of_cards = len(flashcard_set.set_cards)
	
	set_name.text = current_set.set_name
	
	update_card()
	

func update_card() -> void:
	practice_progress.text = "%s / %s" % [current_card, num_of_cards]
	
	card_front.text = current_set.set_cards[current_card].card_front
	card_back.text = current_set.set_cards[current_card].card_back


func finish_set() -> void:
	current_tab = 1
	
	finished_set_name.text = current_set.set_name
	right_percent.text = str((float(right) / float(num_of_cards)) * 100.0) + "%"
	right_number.text = "%s / %s" % [right, num_of_cards]
	
	for flashcard_set: FlashcardsSet in main.sets:
		if flashcard_set == current_set:
			flashcard_set.last_played = Time.get_date_dict_from_system()
			main.save_flashcard_sets()
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flip_card") and main.current_tab == 2:
		_on_flip_card_btn_pressed()
		
	if Input.is_action_just_pressed("right") and main.current_tab == 2:
		_on_right_btn_pressed()
		
	if Input.is_action_just_pressed("wrong") and main.current_tab == 2:
		_on_wrong_btn_pressed()
		
	

func _on_prev_card_btn_pressed() -> void:
	if current_card > 0:
		current_card -= 1
		
	update_card()


func _on_next_card_btn_pressed() -> void:
	if current_card in finished_cards:
		if current_card + 1 < num_of_cards:
			current_card += 1
			
			update_card()
		else:
			finish_set()
	

func _on_flip_card_btn_pressed() -> void:
	if card_side == 0:
		card_side = 1
	else:
		card_side = 0
		
	card_side_tabs.current_tab = card_side	


func _on_right_btn_pressed() -> void:
	if current_card not in finished_cards:
		finished_cards.append(current_card)
		right += 1
	
	_on_next_card_btn_pressed()
	

func _on_wrong_btn_pressed() -> void:
	if current_card not in finished_cards:
		finished_cards.append(current_card)
	
	_on_next_card_btn_pressed()


func _on_practice_again_btn_pressed() -> void:
	practice_set(current_set)


func _on_back_to_sets_btn_pressed() -> void:
	main.current_tab = 0
