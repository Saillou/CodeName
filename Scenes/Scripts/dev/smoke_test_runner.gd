extends SceneTree

const GAME_SCENE := preload("res://Scenes/Game.tscn")
const EXPECTED_CARD_COUNT := 25

func _init() -> void:
	# Init test suite
	print("Smoke test: starting")

	var game = GAME_SCENE.instantiate()
	root.add_child(game)
	await process_frame

	# Start tests
	var failed := false
	failed = _test_card_count() or failed

	# Clean up
	game.queue_free()
	await process_frame

	# Results
	if failed:
		print("Smoke test: failed")
		quit(1)
		return

	print("Smoke test: passed")
	quit(0)

# Tests
func _test_card_count() -> bool:
	var cards := get_nodes_in_group("Cards")
	if cards.size() != EXPECTED_CARD_COUNT:
		push_error("Expected %d cards, got %d" % [EXPECTED_CARD_COUNT, cards.size()])
		return true

	print("PASS: created %d cards" % cards.size())
	return false
