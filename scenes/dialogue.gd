extends CanvasLayer

signal intro_finished

@onready var dialogue_text: Label = %DialogueText
@onready var click_hint: Label = %ClickHint
@onready var header_label: Label = %HeaderLabel
@onready var warning_icon: TextureRect = %WarningIcon
@onready var intro_control: Control = $IntroControl
@onready var dialogue_anchor: Control = $IntroControl/DialogueAnchor

# Center Action Buttons
@onready var action_buttons_center: Control = %ActionButtonsCenter
@onready var btn_start_mission: Button = %BtnStartMission
@onready var btn_how_to_play: Button = %BtnHowToPlay

# Top-Right Utility Buttons (Placeholder Hooks)
@onready var btn_encyclopedia: Button = %BtnEncyclopedia
@onready var btn_badges: Button = %BtnBadges

# How To Play Modal
@onready var how_to_play_modal: PanelContainer = %HowToPlayModal
@onready var btn_close_how_to_play: Button = %BtnCloseHowToPlay
@onready var btn_got_it: Button = %BtnGotIt

var encyclopedia_scene = preload("res://scenes/EncyclopediaModal.tscn")
var encyclopedia_instance: EncyclopediaModal = null

var badges_scene = preload("res://scenes/badges.tscn")
var badges_instance: BadgesModal = null

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
	if warning_icon == null:
		warning_icon = get_node_or_null("%WarningIcon")
	if intro_control == null:
		intro_control = get_node_or_null("IntroControl")
	if dialogue_anchor == null:
		dialogue_anchor = get_node_or_null("IntroControl/DialogueAnchor")
	if action_buttons_center == null:
		action_buttons_center = get_node_or_null("%ActionButtonsCenter")
	if btn_start_mission == null:
		btn_start_mission = get_node_or_null("%BtnStartMission")
	if btn_how_to_play == null:
		btn_how_to_play = get_node_or_null("%BtnHowToPlay")
	if btn_encyclopedia == null:
		btn_encyclopedia = get_node_or_null("%BtnEncyclopedia")
	if btn_badges == null:
		btn_badges = get_node_or_null("%BtnBadges")
	if how_to_play_modal == null:
		how_to_play_modal = get_node_or_null("%HowToPlayModal")
	if btn_close_how_to_play == null:
		btn_close_how_to_play = get_node_or_null("%BtnCloseHowToPlay")
	if btn_got_it == null:
		btn_got_it = get_node_or_null("%BtnGotIt")

	# Ensure signal connections
	if btn_start_mission and not btn_start_mission.pressed.is_connected(_on_start_mission_pressed):
		btn_start_mission.pressed.connect(_on_start_mission_pressed)
	if btn_how_to_play and not btn_how_to_play.pressed.is_connected(_on_how_to_play_pressed):
		btn_how_to_play.pressed.connect(_on_how_to_play_pressed)
	if btn_close_how_to_play and not btn_close_how_to_play.pressed.is_connected(_on_close_modal_pressed):
		btn_close_how_to_play.pressed.connect(_on_close_modal_pressed)
	if btn_got_it and not btn_got_it.pressed.is_connected(_on_close_modal_pressed):
		btn_got_it.pressed.connect(_on_close_modal_pressed)
	if btn_encyclopedia and not btn_encyclopedia.pressed.is_connected(_on_encyclopedia_pressed):
		btn_encyclopedia.pressed.connect(_on_encyclopedia_pressed)
	if btn_badges and not btn_badges.pressed.is_connected(_on_badges_pressed):
		btn_badges.pressed.connect(_on_badges_pressed)

func _enter_tree() -> void:
	_ensure_nodes()

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

	if action_buttons_center:
		action_buttons_center.visible = false

	if how_to_play_modal:
		how_to_play_modal.visible = false

	# Connect action buttons
	if btn_start_mission and not btn_start_mission.pressed.is_connected(_on_start_mission_pressed):
		btn_start_mission.pressed.connect(_on_start_mission_pressed)
	if btn_how_to_play and not btn_how_to_play.pressed.is_connected(_on_how_to_play_pressed):
		btn_how_to_play.pressed.connect(_on_how_to_play_pressed)
	if btn_close_how_to_play and not btn_close_how_to_play.pressed.is_connected(_on_close_modal_pressed):
		btn_close_how_to_play.pressed.connect(_on_close_modal_pressed)
	if btn_got_it and not btn_got_it.pressed.is_connected(_on_close_modal_pressed):
		btn_got_it.pressed.connect(_on_close_modal_pressed)

	# Connect top-right utility buttons
	if btn_encyclopedia and not btn_encyclopedia.pressed.is_connected(_on_encyclopedia_pressed):
		btn_encyclopedia.pressed.connect(_on_encyclopedia_pressed)
	if btn_badges and not btn_badges.pressed.is_connected(_on_badges_pressed):
		btn_badges.pressed.connect(_on_badges_pressed)

	# Instance EncyclopediaModal.tscn (hidden by default) in Intro/Main Menu scene
	if encyclopedia_instance == null or not is_instance_valid(encyclopedia_instance):
		encyclopedia_instance = encyclopedia_scene.instantiate()
		encyclopedia_instance.visible = false
		add_child(encyclopedia_instance)

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
		if action_buttons_center:
			action_buttons_center.visible = false
	else:
		if header_label:
			header_label.text = "🛡️ MISSION DIRECTIVE • ASTRO-CARE COMMAND"
			header_label.modulate = Color(0.2, 0.9, 1.0, 1.0)
		if click_hint:
			click_hint.text = "▶ Select an option below to proceed."
		if action_buttons_center:
			action_buttons_center.visible = true
			action_buttons_center.modulate.a = 0.0
			action_buttons_center.scale = Vector2(0.9, 0.9)
			action_buttons_center.pivot_offset = action_buttons_center.size / 2.0
			var tween = create_tween().set_parallel(true)
			tween.tween_property(action_buttons_center, "modulate:a", 1.0, 0.25)
			tween.tween_property(action_buttons_center, "scale", Vector2(1.0, 1.0), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _input(event: InputEvent) -> void:
	# Ignore input if encyclopedia or badges modal is open
	if encyclopedia_instance and is_instance_valid(encyclopedia_instance) and encyclopedia_instance.visible:
		return
	if badges_instance and is_instance_valid(badges_instance) and badges_instance.visible:
		return

	# Modal handles Escape to close
	if how_to_play_modal and how_to_play_modal.visible:
		if event.is_action_pressed("ui_cancel"):
			_on_close_modal_pressed()
			if is_inside_tree() and get_viewport():
				get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_advance()
	elif event.is_action_pressed("ui_accept"):
		handle_advance()

func _unhandled_input(event: InputEvent) -> void:
	if encyclopedia_instance and is_instance_valid(encyclopedia_instance) and encyclopedia_instance.visible:
		return
	if badges_instance and is_instance_valid(badges_instance) and badges_instance.visible:
		return
	if how_to_play_modal and how_to_play_modal.visible:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_advance()
	elif event.is_action_pressed("ui_accept"):
		handle_advance()

func _on_gui_input(event: InputEvent) -> void:
	if encyclopedia_instance and is_instance_valid(encyclopedia_instance) and encyclopedia_instance.visible:
		return
	if badges_instance and is_instance_valid(badges_instance) and badges_instance.visible:
		return
	if how_to_play_modal and how_to_play_modal.visible:
		return
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

func _on_start_mission_pressed() -> void:
	intro_finished.emit()

func _on_how_to_play_pressed() -> void:
	_ensure_nodes()
	if how_to_play_modal:
		how_to_play_modal.visible = true
		how_to_play_modal.modulate.a = 0.0
		how_to_play_modal.scale = Vector2(0.92, 0.92)
		how_to_play_modal.pivot_offset = how_to_play_modal.size / 2.0
		var tween = create_tween().set_parallel(true)
		tween.tween_property(how_to_play_modal, "modulate:a", 1.0, 0.2)
		tween.tween_property(how_to_play_modal, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_close_modal_pressed() -> void:
	_ensure_nodes()
	if how_to_play_modal:
		how_to_play_modal.visible = false

func _on_encyclopedia_pressed() -> void:
	_ensure_nodes()
	if encyclopedia_instance == null or not is_instance_valid(encyclopedia_instance):
		encyclopedia_instance = encyclopedia_scene.instantiate()
		encyclopedia_instance.visible = false
		add_child(encyclopedia_instance)
	encyclopedia_instance.current_index = 0
	encyclopedia_instance._display_card_data(0)
	encyclopedia_instance.open()

func _on_badges_pressed() -> void:
	_ensure_nodes()
	if badges_instance == null or not is_instance_valid(badges_instance):
		badges_instance = badges_scene.instantiate()
		add_child(badges_instance)
	badges_instance.open()
