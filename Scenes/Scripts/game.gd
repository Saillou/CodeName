@tool
extends Node3D

# Constantes
const WORDS_PATH   := "./resources/WordList.txt"
const CARD_SCENE   := preload("res://Scenes/Card.tscn")
const COLOR_GRAY   := Color(0.7, 0.7, 0.7, 1.0)
const COLOR_RED    := Color(1.0, 0.2, 0.3, 1.0)
const COLOR_BLUE   := Color(0.3, 0.2, 1.0, 1.0)
const COLOR_BLACK  := Color(0.15, 0.15, 0.15, 1.0)
const N_ROWS 	   := 5
const N_COLS 	   := 5
const CARD_MARGIN  := 0.1

# State
var color_pool:Array[Color] = []
var words_pool:Array[String] = []

# Engine
func _ready() -> void:	
	# Read words' file
	var file = FileAccess.open(WORDS_PATH, FileAccess.READ)
	for w in file.get_as_text().split("\n"):
		words_pool.append(w)

	# Create color pool
	for i in range(8):
		color_pool.append(COLOR_BLUE)
		color_pool.append(COLOR_RED)
		color_pool.append(COLOR_GRAY)
	color_pool.append(COLOR_BLACK)	

	# Create cards
	for y in range(0, N_COLS):
		for x in range(0, N_ROWS):
			var card: CardElement = CARD_SCENE.instantiate() as CardElement
			var card_pos:= Vector3(0, 0, 0)
			card_pos.x = (CARD_MARGIN + card.width())*(x - (N_ROWS-1.0)/2.0)
			card_pos.y = (CARD_MARGIN + card.height())*((N_COLS-1.0)/2.0 - y)
			card.position = card_pos
			card.data.index = x + y * N_ROWS
			card.flipped.connect(_flipped)
			add_child(card)

	# Init cards
	_generate_card_values(0.001)

	# Signals
	%BtnRegenerate.pressed.connect(_generate_card_values)

# Methods
func _randomize_pools() -> void:
	color_pool.shuffle()
	words_pool.shuffle()

func _generate_card_values(delay_between_cards: float = 0.03) -> void:
	%Answer.clear_data()

	_randomize_pools()

	for node in get_tree().get_nodes_in_group("Cards"):
		if node is not CardElement:
			continue

		var card: CardElement = node as CardElement
		card.reset_face()
		card.set_back_color(COLOR_GRAY * 0.6)
		card.set_front_color(color_pool[card.data.index])
		card.set_text(words_pool[card.data.index])

		if delay_between_cards > 0:
			await get_tree().create_timer(delay_between_cards).timeout

	%Answer.refresh_data()

func _flipped(_card) -> void:
	# Play sound
	%FlipSound.pitch_scale = randf_range(0.8, 1.2)
	%FlipSound.play()
