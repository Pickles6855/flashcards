class_name FlashcardsSet
extends Resource

@export var set_name: String
@export var set_cards: Array[Flashcard] = [Flashcard.new()]
@export var tags: Array[String] = []
@export var last_played: Dictionary
