@tool
extends Window
class_name GameAnswer

# Constantes
const CONFIG 	 := preload("res://Scenes/Scripts/game_config.gd")
const CELL_SIZE  := Vector2i(50, 30)
const MARGIN     := Vector2i(50, 50)
const GAP_WINDOW := 16

# Engine
func _ready() -> void:
	call_deferred("_late_init")

# Methods
func clear_data() -> void:
	# Clear previous
	for child in %Grid.get_children():
		child.queue_free()

	for node in get_tree().get_nodes_in_group("Cards"):
		if node is not CardElement:
			continue
			
		var rect := ColorRect.new()
		rect.color = CONFIG.COLOR_GRAY
		rect.custom_minimum_size = CELL_SIZE
		%Grid.add_child(rect)

func refresh_data() -> void:
	# Clear previous
	for child in %Grid.get_children():
		child.queue_free()

	for node in get_tree().get_nodes_in_group("Cards"):
		if node is not CardElement:
			continue
			
		var card: CardElement = node as CardElement
		var rect := ColorRect.new()
		rect.color = card.data.color
		rect.custom_minimum_size = CELL_SIZE
		%Grid.add_child(rect)

# Don't close the window
func _on_close_requested() -> void:
	pass

func _place_next_to_main() -> void:
	var main_window := get_tree().root

	initial_position = Window.WINDOW_INITIAL_POSITION_ABSOLUTE
	position = Vector2i(
		main_window.position.x + main_window.size.x + GAP_WINDOW,
		main_window.position.y
	)
	size = Vector2i(
		CONFIG.N_ROWS * CELL_SIZE.x + 4, 
		CONFIG.N_COLS * CELL_SIZE.y + 4
	) + MARGIN

# Tricks to place the window
func _late_init() -> void:
	await get_tree().process_frame
	_place_next_to_main()
	set_flag(FLAG_RESIZE_DISABLED, true)
	set_flag(FLAG_MAXIMIZE_DISABLED, true)