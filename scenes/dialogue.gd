class_name IntroDialogue
extends CanvasLayer

signal intro_finished

@onready var dialogue_text: Label = %DialogueText
@onready var click_hint: Label = %ClickHint
@onready var header_label: Label = %HeaderLabel
@onready var btn_start: Button = %BtnStart
@onready var warning_icon: TextureRect = %WarningIcon
@onready var intro_control: Control = $IntroControl
@onready var dialogue_anchor: Control = $IntroControl/DialogueAnchor

var dialogue_index: int = 0
var is_advancing: bool = false

const DIALOGUE_STEPS: Array[String] = [
	"Warning: Oxygen levels dropping in sector 4. Radiation spike detected. You have 30 seconds before life support fails...",
	"Emergency protocols engaged, Commander. Manage life support, shield the habitat from solar storms, and keep the crew alive for 30 Sols!"
]

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
	if intro_control == null:
		intro_control = get_node_or_null("IntroControl")
	if dialogue_anchor == null:
		dialogue_anchor = get_node_or_null("IntroControl/DialogueAnchor")

func _ready() -> void:
	_ensure_nodes()
	dialogue_index = 0
	is_advancing = false
	
	if intro_control:
		intro_control.mouse_filter = Control.MOUSE_FILTER_PASS
		if not intro_control.gui_input.is_connected(_on_gui_input):
			intro_control.gui_input.connect(_on_gui_input)
			
	if dialogue_anchor:
		dialogue_anchor.mouse_filter = Control.MOUSE_FILTER_PASS
		if not dialogue_anchor.gui_input.is_connected(_on_gui_input):
			dialogue_anchor.gui_input.connect(_on_gui_input)

	if btn_start:
		btn_start.visible = false
		if not btn_start.pressed.is_connected(_on_start_pressed):
			btn_start.pressed.connect(_on_start_pressed)

	show_dialogue_step(0)

func show_dialogue_step(index: int) -> void:
	_ensure_nodes()
	dialogue_index = index
	
	if dialogue_text:
		dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		if index >= 0 and index < DIALOGUE_STEPS.size():
			dialogue_text.text = DIALOGUE_STEPS[index]
	
	if index == 0:
		if header_label:
			header_label.text = "⚠️ CRITICAL ALERT • SECTOR 4"
			header_label.modulate = Color(1.0, 0.35, 0.25, 1.0)
		if click_hint:
			click_hint.text = "▶ Click anywhere to continue..."
			click_hint.visible = true
		if btn_start:
			btn_start.visible = false
	else:
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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_advance()
	elif event.is_action_pressed("ui_accept"):
		handle_advance()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_advance()
	elif event.is_action_pressed("ui_accept"):
		handle_advance()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_advance()

func handle_advance() -> void:
	if is_advancing:
		return
	_ensure_nodes()
	
	if dialogue_index < DIALOGUE_STEPS.size() - 1:
		is_advancing = true
		dialogue_index += 1
		show_dialogue_step(dialogue_index)
		if is_inside_tree():
			if get_viewport():
				get_viewport().set_input_as_handled()
			var tree = get_tree()
			if tree:
				await tree.create_timer(0.2).timeout
		is_advancing = false
	else:
		# If START button is already visible and user clicks, start mission
		_on_start_pressed()

func _on_start_pressed() -> void:
	intro_finished.emit()
