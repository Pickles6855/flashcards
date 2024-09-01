extends PanelContainer

signal text_boxes_ready

var front_text: TextEdit
var back_text: TextEdit
var card_indx: int

func _enter_tree() -> void:
	front_text = $HBoxContainer/FrontText
	back_text = $HBoxContainer/BackText
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		if front_text.has_focus():
			back_text.grab_focus()
			
		elif back_text.has_focus():
			
			var siblings: Array[Node] = get_parent().get_children()
			var self_indx: int = siblings.find(self)
	
			if len(siblings) - 1 <= self_indx:
				find_parent("EditSet")._on_new_card_btn_pressed()
				siblings = get_parent().get_children()
				focus_next_card(siblings, self_indx)
			else:
				focus_next_card(siblings, self_indx)
		
		front_text.text =  front_text.text.replace("	", "")
		back_text.text =  back_text.text.replace("	", "")
				
			

func focus_next_card(siblings: Array[Node], self_indx: int) -> void:
	siblings[self_indx + 1].front_text.call_deferred("grab_focus")
	
			
