@tool
extends Node3D

# Constantes
const WORDS_PATH   := "res://resources/WordList.txt"
const CARD_SCENE   := preload("res://Scenes/Card.tscn")
const CONFIG 	   := preload("res://Scenes/Scripts/game_config.gd")
const CARD_MARGIN  := 0.1

# State
var color_pool:Array[Color] = []
var words_pool:Array[String] = []

# Engine
func _ready() -> void:	
	# Read words' file
	var file = FileAccess.open(WORDS_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open words file: %s" % WORDS_PATH)
		return

	for w in file.get_as_text().split("\n"):
		var word := w.strip_edges()
		if not word.is_empty():
			words_pool.append(word)

	# Create color pool
	for i in range(8):
		color_pool.append(CONFIG.COLOR_BLUE)
		color_pool.append(CONFIG.COLOR_RED)
		color_pool.append(CONFIG.COLOR_GRAY)
	color_pool.append(CONFIG.COLOR_BLACK)	

	# Create cards
	for y in range(0, CONFIG.N_COLS):
		for x in range(0, CONFIG.N_ROWS):
			var card: CardElement = CARD_SCENE.instantiate() as CardElement
			card.data.index = x + y * CONFIG.N_ROWS
			card.position = _card_grid_position(card, x, y)
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

func _card_grid_position(card: CardElement, x: int, y: int) -> Vector3:
	var step := card.size() + Vector2(CARD_MARGIN, CARD_MARGIN)
	return Vector3(
		step.x * (x - (CONFIG.N_ROWS - 1.0) / 2.0),
		step.y * ((CONFIG.N_COLS - 1.0) / 2.0 - y),
		0.0
	)

func _generate_card_values(delay_between_cards: float = 0.03) -> void:
	%Answer.clear_data()

	_randomize_pools()

	for node in get_tree().get_nodes_in_group("Cards"):
		if node is not CardElement:
			continue

		var card: CardElement = node as CardElement
		card.reset_face()
		card.set_back_color(CONFIG.COLOR_GRAY * 0.6)
		card.set_front_color(color_pool[card.data.index])
		card.set_text(words_pool[card.data.index])

		if delay_between_cards > 0:
			%CardDelay.start(delay_between_cards)
			await %CardDelay.timeout

	%Answer.refresh_data()

func _flipped(_card) -> void:
	# Play sound
	%FlipSound.pitch_scale = randf_range(0.8, 1.2)
	%FlipSound.play()
