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

# Top-Right Utility Buttons
@onready var btn_encyclopedia: Button = %BtnEncyclopedia
@onready var btn_badges: Button = %BtnBadges

# How To Play Modal
@onready var how_to_play_modal: PanelContainer = %HowToPlayModal
@onready var btn_close_how_to_play: Button = %BtnCloseHowToPlay
@onready var btn_got_it: Button = %BtnGotIt

# Crew Team Section
@onready var crew_section: Control = %CrewSection if has_node("%CrewSection") else null
@onready var crew_avatar_1: TextureRect = %CrewAvatar1 if has_node("%CrewAvatar1") else null
@onready var crew_avatar_2: TextureRect = %CrewAvatar2 if has_node("%CrewAvatar2") else null
@onready var crew_avatar_3: TextureRect = %CrewAvatar3 if has_node("%CrewAvatar3") else null
@onready var crew_avatar_4: TextureRect = %CrewAvatar4 if has_node("%CrewAvatar4") else null
@onready var crew_speech_bubble: PanelContainer = %CrewSpeechBubble if has_node("%CrewSpeechBubble") else null
@onready var crew_speech_text: Label = %CrewSpeechText if has_node("%CrewSpeechText") else null

var encyclopedia_scene = preload("res://scenes/EncyclopediaModal.tscn")
var encyclopedia_instance: EncyclopediaModal = null

var badges_scene = preload("res://scenes/badges.tscn")
var badges_instance: BadgesModal = null

var dialogue_index: int = 0
var is_advancing: bool = false
var is_typewriting: bool = false
var typewriter_tween: Tween = null
var current_target_text: String = ""
var current_phase: String = "intro"  # "intro", "crew_teaser", "menu"

# Audio
var audio_typewriter: AudioStreamPlayer = null
var audio_click: AudioStreamPlayer = null
var sfx_astrobot_speak: AudioStream = null
var sfx_click: AudioStream = null

# ─── Storytelling Steps ──────────────────────────────────────────────
const INTRO_STEPS: Array[Dictionary] = [
	{
		"header": "📡 INCOMING TRANSMISSION • ARES-4 HABITAT",
		"header_color": [0.0, 0.85, 1.0, 1.0],
		"text": "Year 2026. Humanity's first deep-space outpost on Mars stands on the edge of the red frontier—isolated, fragile, and 225 million kilometers from home."
	},
	{
		"header": "⚠️ SOLAR OBSERVATORY ALERT • DEEP SPACE",
		"header_color": [1.0, 0.35, 0.25, 1.0],
		"text": "Deep-space sensors have detected a massive surge in solar activity. Deadly X-class flares and coronal mass ejections are hurtling straight toward our sector."
	},
	{
		"header": "☢️ CRITICAL SYSTEM WARNING • LIFE SUPPORT",
		"header_color": [1.0, 0.6, 0.15, 1.0],
		"text": "Power grids, oxygen recyclers, crops, and radiation shields are pushed to their limits. Every choice you make will decide who survives the storm."
	},
	{
		"header": "🛡️ MISSION DIRECTIVE • ASTRO-CARE COMMAND",
		"header_color": [0.2, 0.95, 0.7, 1.0],
		"text": "Take command, Commander. Survive 30 Martian Sols, protect the crew from lethal radiation, and keep humanity's hope alive."
	},
]

const CREW_TEASER_TEXT: String = "Are you ready to face the red storms, Commander? Let's secure the habitat!"

func _ready() -> void:
	_ensure_nodes()
	_load_audio()
	dialogue_index = 0
	is_advancing = false
	current_phase = "intro"

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
	if crew_section:
		crew_section.visible = false
		crew_section.modulate.a = 0.0
	if crew_speech_bubble:
		crew_speech_bubble.visible = false
		crew_speech_bubble.modulate.a = 0.0

	# Connect action buttons
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

	# Pre-instance EncyclopediaModal
	if encyclopedia_instance == null or not is_instance_valid(encyclopedia_instance):
		encyclopedia_instance = encyclopedia_scene.instantiate()
		encyclopedia_instance.visible = false
		add_child(encyclopedia_instance)

	# Start first intro step with typewriter
	_show_intro_step(0)

func _load_audio() -> void:
	# Create AudioStreamPlayers
	audio_typewriter = AudioStreamPlayer.new()
	audio_typewriter.bus = "Master"
	audio_typewriter.volume_db = -6.0
	add_child(audio_typewriter)

	audio_click = AudioStreamPlayer.new()
	audio_click.bus = "Master"
	audio_click.volume_db = -4.0
	add_child(audio_click)

	# Load typing sound
	if ResourceLoader.exists("res://assets/audios/astrobot_speak.wav"):
		sfx_astrobot_speak = load("res://assets/audios/astrobot_speak.wav")
	elif ResourceLoader.exists("res://assets/audio/sound effects/typing.mp3"):
		sfx_astrobot_speak = load("res://assets/audio/sound effects/typing.mp3")

	# Load click sound
	if ResourceLoader.exists("res://assets/audio/sound effects/click.mp3.mp3"):
		sfx_click = load("res://assets/audio/sound effects/click.mp3.mp3")
	elif ResourceLoader.exists("res://assets/audio/sound effects/pop up bot.mp3"):
		sfx_click = load("res://assets/audio/sound effects/pop up bot.mp3")

func _ensure_nodes() -> void:
	if dialogue_text == null: dialogue_text = get_node_or_null("%DialogueText")
	if click_hint == null: click_hint = get_node_or_null("%ClickHint")
	if header_label == null: header_label = get_node_or_null("%HeaderLabel")
	if warning_icon == null: warning_icon = get_node_or_null("%WarningIcon")
	if intro_control == null: intro_control = get_node_or_null("IntroControl")
	if dialogue_anchor == null: dialogue_anchor = get_node_or_null("IntroControl/DialogueAnchor")
	if action_buttons_center == null: action_buttons_center = get_node_or_null("%ActionButtonsCenter")
	if btn_start_mission == null: btn_start_mission = get_node_or_null("%BtnStartMission")
	if btn_how_to_play == null: btn_how_to_play = get_node_or_null("%BtnHowToPlay")
	if btn_encyclopedia == null: btn_encyclopedia = get_node_or_null("%BtnEncyclopedia")
	if btn_badges == null: btn_badges = get_node_or_null("%BtnBadges")
	if how_to_play_modal == null: how_to_play_modal = get_node_or_null("%HowToPlayModal")
	if btn_close_how_to_play == null: btn_close_how_to_play = get_node_or_null("%BtnCloseHowToPlay")
	if btn_got_it == null: btn_got_it = get_node_or_null("%BtnGotIt")
	if crew_section == null: crew_section = get_node_or_null("%CrewSection")
	if crew_avatar_1 == null: crew_avatar_1 = get_node_or_null("%CrewAvatar1")
	if crew_avatar_2 == null: crew_avatar_2 = get_node_or_null("%CrewAvatar2")
	if crew_avatar_3 == null: crew_avatar_3 = get_node_or_null("%CrewAvatar3")
	if crew_avatar_4 == null: crew_avatar_4 = get_node_or_null("%CrewAvatar4")
	if crew_speech_bubble == null: crew_speech_bubble = get_node_or_null("%CrewSpeechBubble")
	if crew_speech_text == null: crew_speech_text = get_node_or_null("%CrewSpeechText")

# ─── Intro Storytelling ──────────────────────────────────────────────

func _show_intro_step(index: int) -> void:
	_ensure_nodes()
	dialogue_index = index

	if index < 0 or index >= INTRO_STEPS.size():
		return

	var step = INTRO_STEPS[index]

	# Show dialogue anchor, hide crew section
	if dialogue_anchor:
		dialogue_anchor.visible = true
	if crew_section:
		crew_section.visible = false

	# Update header
	if header_label:
		header_label.text = step["header"]
		var hc = step["header_color"]
		header_label.modulate = Color(hc[0], hc[1], hc[2], hc[3])

	# Update click hint
	if click_hint:
		click_hint.text = "▶ Click anywhere to continue..."
		click_hint.visible = true

	# Hide buttons during intro
	if action_buttons_center:
		action_buttons_center.visible = false

	# Fade in with typewriter
	if dialogue_anchor:
		dialogue_anchor.modulate.a = 0.0
		var fade = create_tween()
		fade.tween_property(dialogue_anchor, "modulate:a", 1.0, 0.2)

	_start_typewriter(step["text"], dialogue_text)

func _transition_to_crew_teaser() -> void:
	current_phase = "crew_teaser"

	# Fade out the dialogue anchor
	if dialogue_anchor:
		var fade_out = create_tween()
		fade_out.tween_property(dialogue_anchor, "modulate:a", 0.0, 0.3)
		await fade_out.finished
		dialogue_anchor.visible = false

	# Show crew section with avatars popping in
	if crew_section:
		crew_section.visible = true
		crew_section.modulate.a = 0.0
		var fade_in = create_tween()
		fade_in.tween_property(crew_section, "modulate:a", 1.0, 0.4)
		await fade_in.finished

	# Pop in each avatar sequentially
	var avatars = [crew_avatar_1, crew_avatar_2, crew_avatar_3, crew_avatar_4]
	for avatar in avatars:
		if avatar:
			avatar.modulate.a = 0.0
			avatar.scale = Vector2(0.5, 0.5)
			avatar.pivot_offset = avatar.size / 2.0
	
	for i in range(avatars.size()):
		var avatar = avatars[i]
		if avatar:
			var pop = create_tween().set_parallel(true)
			pop.tween_property(avatar, "modulate:a", 1.0, 0.2)
			pop.tween_property(avatar, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			await pop.finished
			# Small delay between each pop
			if i < avatars.size() - 1:
				await get_tree().create_timer(0.12).timeout

	# Show crew speech bubble with typewriter
	if crew_speech_bubble:
		crew_speech_bubble.visible = true
		crew_speech_bubble.modulate.a = 0.0
		var bubble_fade = create_tween()
		bubble_fade.tween_property(crew_speech_bubble, "modulate:a", 1.0, 0.25)
		await bubble_fade.finished

	_start_typewriter(CREW_TEASER_TEXT, crew_speech_text)

func _transition_to_menu() -> void:
	current_phase = "menu"

	# Update click hint to indicate menu is ready
	if click_hint:
		click_hint.visible = false

	# Show action buttons with smooth fade-in
	if action_buttons_center:
		action_buttons_center.visible = true
		action_buttons_center.modulate.a = 0.0
		action_buttons_center.scale = Vector2(0.85, 0.85)
		action_buttons_center.pivot_offset = action_buttons_center.size / 2.0
		var tween = create_tween().set_parallel(true)
		tween.tween_property(action_buttons_center, "modulate:a", 1.0, 0.35)
		tween.tween_property(action_buttons_center, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ─── Typewriter Engine ───────────────────────────────────────────────

func _start_typewriter(target_text: String, label: Label) -> void:
	if not label:
		return
	if typewriter_tween:
		typewriter_tween.kill()

	label.text = ""
	current_target_text = target_text
	is_typewriting = true

	typewriter_tween = create_tween()
	var char_duration := 0.028
	var text_len := target_text.length()

	for i in range(1, text_len + 1):
		typewriter_tween.tween_callback(func():
			if not is_typewriting:
				return
			label.text = target_text.substr(0, i)
			# Play typing blip every 3 characters
			if i % 3 == 0 and audio_typewriter and sfx_astrobot_speak:
				audio_typewriter.stream = sfx_astrobot_speak
				audio_typewriter.pitch_scale = randf_range(0.92, 1.12)
				audio_typewriter.play()
		)
		typewriter_tween.tween_interval(char_duration)

	typewriter_tween.finished.connect(func():
		is_typewriting = false
		_stop_typing_audio()
	)

func _finish_typewriting(label: Label) -> void:
	if typewriter_tween:
		typewriter_tween.kill()
	is_typewriting = false
	_stop_typing_audio()
	if label:
		label.text = current_target_text

func _stop_typing_audio() -> void:
	if audio_typewriter and audio_typewriter.playing:
		audio_typewriter.stop()

func _play_click_sound() -> void:
	if audio_click and sfx_click:
		audio_click.stream = sfx_click
		audio_click.play()

# ─── Input Handling ──────────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	# Ignore input if modals are open
	if encyclopedia_instance and is_instance_valid(encyclopedia_instance) and encyclopedia_instance.visible:
		return
	if badges_instance and is_instance_valid(badges_instance) and badges_instance.visible:
		return
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

	_play_click_sound()

	match current_phase:
		"intro":
			_handle_intro_advance()
		"crew_teaser":
			_handle_crew_teaser_advance()
		"menu":
			pass  # Menu buttons handle their own presses

func _handle_intro_advance() -> void:
	_ensure_nodes()

	# If typewriter is running, skip to full text
	if is_typewriting:
		_finish_typewriting(dialogue_text)
		return

	# Advance to next intro step
	if dialogue_index < INTRO_STEPS.size() - 1:
		is_advancing = true
		dialogue_index += 1
		_show_intro_step(dialogue_index)

		if is_inside_tree() and get_viewport():
			get_viewport().set_input_as_handled()
		if is_inside_tree():
			var tree = get_tree()
			if tree:
				await tree.create_timer(0.2).timeout
		is_advancing = false
	else:
		# Last intro step done — transition to crew teaser
		is_advancing = true
		_transition_to_crew_teaser()
		is_advancing = false

func _handle_crew_teaser_advance() -> void:
	# If typewriter is running, skip to full text
	if is_typewriting:
		_finish_typewriting(crew_speech_text)
		return

	# Crew teaser done — show menu buttons
	is_advancing = true
	_transition_to_menu()
	is_advancing = false

# ─── Button Handlers ─────────────────────────────────────────────────

func _on_start_mission_pressed() -> void:
	_play_click_sound()
	intro_finished.emit()

func _on_how_to_play_pressed() -> void:
	_play_click_sound()
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
	_play_click_sound()
	_ensure_nodes()
	if how_to_play_modal:
		how_to_play_modal.visible = false

func _on_encyclopedia_pressed() -> void:
	_play_click_sound()
	_ensure_nodes()
	if encyclopedia_instance == null or not is_instance_valid(encyclopedia_instance):
		encyclopedia_instance = encyclopedia_scene.instantiate()
		encyclopedia_instance.visible = false
		add_child(encyclopedia_instance)
	encyclopedia_instance.current_index = 0
	encyclopedia_instance._display_card_data(0)
	encyclopedia_instance.open()

func _on_badges_pressed() -> void:
	_play_click_sound()
	_ensure_nodes()
	if badges_instance == null or not is_instance_valid(badges_instance):
		badges_instance = badges_scene.instantiate()
		add_child(badges_instance)
	badges_instance.open()
