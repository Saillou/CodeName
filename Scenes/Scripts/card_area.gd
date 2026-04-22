@tool
extends Area3D

signal clicked
signal hovered
signal unhovered

func _ready():
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	hovered.emit()

func _on_mouse_exited():
	unhovered.emit()

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	# Filter inputs: mouse only
	if event is not InputEventMouseButton:
		return

	# Left click
	var mouseEvent:InputEventMouseButton = event as InputEventMouseButton
	if mouseEvent.button_index == MOUSE_BUTTON_LEFT and mouseEvent.pressed:
		clicked.emit()