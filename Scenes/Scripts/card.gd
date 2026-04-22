@tool
extends Node3D
class_name CardElement

signal flipped

# Contantes
const HOVER_DURATION := 0.16
const HOVER_ANGLE 	 := 15.0
const FLIP_DURATION  := 0.22
const FLIP_ANGLE 	 := 180.0

# Public data
@export var data: CardData = CardData.new()

# Internal state
var _flipped: bool = false

# Members
var _tween_hover: Tween
var _tween_flip: Tween

# API
func set_text(value: String) -> void:
	$Front/Text.set_text(value)
	$Back/Text.set_text(value)

func set_back_color(color: Color) -> void:
	_edit_color(%Back, color)

func set_front_color(color: Color) -> void:
	data.color = color
	_edit_color(%Front, color)

func size() -> Vector2:
	return (%Front.mesh as QuadMesh).size

func width() -> float:
	return size().x

func height() -> float:
	return size().y

func reset_face() -> void:
	if not _flipped:
		return

	_flip(false)

# Engine
func _ready():
	%MouseArea.clicked.connect(_on_clicked)
	%MouseArea.hovered.connect(_on_hovered)
	%MouseArea.unhovered.connect(_on_unhovered)

# Signals
func _on_hovered() -> void:
	if _flipped:
		return
	_tween_hover = _anime_rotate_x(_tween_hover, HOVER_ANGLE, HOVER_DURATION)

func _on_unhovered() -> void:
	if _flipped:
		return
	_tween_hover = _anime_rotate_x(_tween_hover, 0.0, HOVER_DURATION)

func _on_clicked() -> void:
	if _flipped:
		return
	_flip(true)

# Helpers
func _flip(face_up) -> void:
	_flipped = face_up
	_tween_flip  = _anime_rotate_x(_tween_flip, FLIP_ANGLE if _flipped else 0.0, FLIP_DURATION)
	flipped.emit(self)

func _anime_rotate_x(tween: Tween, value: Variant, duration: float) -> Tween:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_degrees:x", value, duration)
	return tween

func _edit_color(mesh:MeshInstance3D, color: Color) -> void:
	(mesh.material_override as StandardMaterial3D).albedo_color = color
