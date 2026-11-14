class_name IntroDialogue
extends CanvasLayer

signal intro_finished

@onready var dialogue_text: Label = %DialogueText
@onready var click_hint: Label = %ClickHint
@onready var header_label: Label = %HeaderLabel
@onready var btn_start: Button = %BtnStart
@onready var warning_icon: TextureRect = %WarningIcon

var current_step: int = 1
const STEP_1_TEXT: String = "Warning: Oxygen levels dropping in sector 4. Radiation spike detected. You have 30 seconds before life support fails..."
const STEP_2_TEXT: String = "Emergency protocols engaged, Commander. Manage life support, shield the habitat from solar storms, and keep the crew alive for 30 Sols!"

func _ensure_nodes() -> void:
	if dialogue_text == null:
		dialogue_text = get_node_or_null("%DialogueText")
	if click_hint == null:
		click_hint = get_node_or_null("%ClickHint")
	if header_label == null:
		header_label = get_node_or_null("%HeaderLabel")
	if btn_start == null:
		btn_start = get_node_or_null("%BtnStart")
	if warning_icon == null:
		warning_icon = get_node_or_null("%WarningIcon")

func _ready() -> void:
	_ensure_nodes()
	current_step = 1
	if dialogue_text:
		dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dialogue_text.text = STEP_1_TEXT
	if click_hint:
		click_hint.text = "▶ Click anywhere to continue..."
		click_hint.visible = true
	if header_label:
		header_label.text = "⚠️ CRITICAL ALERT • SECTOR 4"
		header_label.modulate = Color(1.0, 0.35, 0.25, 1.0)
	if btn_start:
		btn_start.visible = false
		if not btn_start.pressed.is_connected(_on_start_pressed):
			btn_start.pressed.connect(_on_start_pressed)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_advance()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_advance()
	elif event.is_action_pressed("ui_accept"):
		handle_advance()

func handle_advance() -> void:
	_ensure_nodes()
	if current_step == 1:
		advance_to_step_2()
	elif current_step == 2:
		_on_start_pressed()

func advance_to_step_2() -> void:
	_ensure_nodes()
	current_step = 2
	if dialogue_text:
		dialogue_text.text = STEP_2_TEXT
	if header_label:
		header_label.text = "🛡️ MISSION DIRECTIVE • ASTRO-CARE COMMAND"
		header_label.modulate = Color(0.2, 0.9, 1.0, 1.0)
	if click_hint:
		click_hint.text = "▶ Ready to command? Click START to initiate mission."
	if btn_start:
		btn_start.visible = true
		btn_start.modulate.a = 0.0
		btn_start.scale = Vector2(0.85, 0.85)
		btn_start.pivot_offset = btn_start.size / 2.0
		var tween = create_tween().set_parallel(true)
		tween.tween_property(btn_start, "modulate:a", 1.0, 0.25)
		tween.tween_property(btn_start, "scale", Vector2(1.0, 1.0), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_start_pressed() -> void:
	intro_finished.emit()
