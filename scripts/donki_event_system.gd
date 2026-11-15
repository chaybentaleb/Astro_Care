class_name DonkiEventSystem
extends CanvasLayer

## UI controller for NASA & CSA Expeditions (Events 1 to 30)

@onready var game_manager: GameManager = $GameManager
@onready var root_control: Control = $RootControl

# Top HUD - Vital Ship & Crew Telemetry
@onready var energy_bar: ProgressBar = %EnergyBar
@onready var energy_val: Label = %EnergyVal
@onready var oxygen_bar: ProgressBar = %OxygenBar
@onready var oxygen_val: Label = %OxygenVal
@onready var shield_bar: ProgressBar = %ShieldBar
@onready var shield_val: Label = %ShieldVal
@onready var radiation_bar: ProgressBar = %RadiationBar
@onready var radiation_val: Label = %RadiationVal
@onready var rad_badge: Label = %RadBadge

# Extended Vital Resources
@onready var health_bar: ProgressBar = %HealthBar if has_node("%HealthBar") else null
@onready var health_val: Label = %HealthVal if has_node("%HealthVal") else null
@onready var food_bar: ProgressBar = %FoodBar if has_node("%FoodBar") else null
@onready var food_val: Label = %FoodVal if has_node("%FoodVal") else null
@onready var water_bar: ProgressBar = %WaterBar if has_node("%WaterBar") else null
@onready var water_val: Label = %WaterVal if has_node("%WaterVal") else null

# Event Terminal Elements
@onready var event_counter: Label = %EventCounter
@onready var event_title: Label = %EventTitle
@onready var event_scenario: Label = %EventScenario

# Astro-Bot Tactical Advice & Sidebar
@onready var astrobot_sidebar: Control = %AstrobotSidebar if has_node("%AstrobotSidebar") else null
@onready var btn_astrobot_avatar: TextureButton = %BtnAstrobotAvatar if has_node("%BtnAstrobotAvatar") else null
@onready var astrobot_nameplate: Label = %AstrobotNameplate if has_node("%AstrobotNameplate") else null
@onready var astrobot_mood_badge: Label = %AstrobotMoodBadge if has_node("%AstrobotMoodBadge") else null
@onready var avatar_frame: PanelContainer = %AvatarFrame if has_node("%AvatarFrame") else null
@onready var speech_bubble: PanelContainer = %SpeechBubble if has_node("%SpeechBubble") else null
@onready var bubble_title: Label = %BubbleTitle if has_node("%BubbleTitle") else null
@onready var bubble_text: Label = %BubbleText if has_node("%BubbleText") else null
@onready var btn_close_bubble: Button = %BtnCloseBubble if has_node("%BtnCloseBubble") else null
@onready var bubble_prompt: Label = %BubblePrompt if has_node("%BubblePrompt") else null

# Hint & Encyclopedia inside speech bubble
@onready var btn_bubble_hint: Button = %BtnBubbleHint if has_node("%BtnBubbleHint") else null
@onready var hint_panel: PanelContainer = %HintPanel if has_node("%HintPanel") else null
@onready var hint_text: Label = %HintText if has_node("%HintText") else null
@onready var btn_bubble_encyclopedia_link: Button = %BtnBubbleEncyclopediaLink if has_node("%BtnBubbleEncyclopediaLink") else null

# Audio Stream Players
@onready var audio_mood_popup: AudioStreamPlayer = %AudioMoodPopup if has_node("%AudioMoodPopup") else null
@onready var audio_typewriter: AudioStreamPlayer = %AudioTypewriter if has_node("%AudioTypewriter") else null
@onready var heartbeat_audio: AudioStreamPlayer = %HeartbeatAudio
@onready var breathing_audio: AudioStreamPlayer = %BreathingAudio
@onready var failure_audio: AudioStreamPlayer = %FailureAudio

var sfx_heartbeat: AudioStream = null
var sfx_breathing: AudioStream = null
var sfx_failure: AudioStream = null

var is_heartbeat_playing: bool = false
var is_breathing_playing: bool = false
var heartbeat_tween: Tween = null
var breathing_tween: Tween = null



# Choice Buttons (A, B, C, D)
@onready var btn_choice_a: Button = %BtnChoiceA
@onready var label_choice_a_text: Label = %ChoiceAText
@onready var label_choice_a_impact: Label = %ChoiceAImpact

@onready var btn_choice_b: Button = %BtnChoiceB
@onready var label_choice_b_text: Label = %ChoiceBText
@onready var label_choice_b_impact: Label = %ChoiceBImpact

@onready var btn_choice_c: Button = %BtnChoiceC if has_node("%BtnChoiceC") else null
@onready var label_choice_c_text: Label = %ChoiceCText if has_node("%ChoiceCText") else null
@onready var label_choice_c_impact: Label = %ChoiceCImpact if has_node("%ChoiceCImpact") else null

@onready var btn_choice_d: Button = %BtnChoiceD if has_node("%BtnChoiceD") else null
@onready var label_choice_d_text: Label = %ChoiceDText if has_node("%ChoiceDText") else null
@onready var label_choice_d_impact: Label = %ChoiceDImpact if has_node("%ChoiceDImpact") else null

# Feedback & Modal Panels
@onready var feedback_panel: PanelContainer = %FeedbackPanel
@onready var feedback_label: Label = %FeedbackLabel
@onready var game_over_panel: PanelContainer = %GameOverPanel
@onready var game_over_reason: Label = %GameOverReason
@onready var game_over_stats: Label = %GameOverStats
@onready var btn_restart_game_over: Button = %BtnRestartGameOver

@onready var victory_panel: PanelContainer = %VictoryPanel
@onready var victory_title: Label = %VictoryTitle if has_node("%VictoryTitle") else null
@onready var victory_subtitle: Label = %VictorySubtitle if has_node("%VictorySubtitle") else null
@onready var victory_stats: Label = %VictoryStats
@onready var victory_rating: Label = %VictoryRating
@onready var btn_restart_victory: Button = %BtnRestartVictory

# Mode Selectors removed - Events progress naturally in ALL mode
var encyclopedia_scene = preload("res://scenes/EncyclopediaModal.tscn")
var encyclopedia_instance: EncyclopediaModal = null

var badges_scene = preload("res://scenes/badges.tscn")
var badges_instance: BadgesModal = null

var current_event_data: Dictionary = {}
var is_processing_choice: bool = false
var default_mode: String = "ALL"

# Astrobot Mood Textures & Audio Streams
var tex_optimal: Texture2D = null
var tex_critical: Texture2D = null
var tex_warning: Texture2D = null
var tex_science: Texture2D = null

var sfx_alert_red: AudioStream = null
var sfx_warning_yellow: AudioStream = null
var sfx_optimal_beep: AudioStream = null
var sfx_astrobot_speak: AudioStream = null

var current_dialogue_target: String = ""
var typewriter_tween: Tween = null
var is_typewriting: bool = false
var active_mood: String = "Optimal"

# Badge Manager reference (autoload singleton)
var badge_manager: Node = null

func _ready() -> void:
	feedback_panel.visible = false
	game_over_panel.visible = false
	victory_panel.visible = false

	# Ensure responsive autowrapping on all title and description labels
	if event_title:
		event_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if event_scenario:
		event_scenario.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if label_choice_a_text:
		label_choice_a_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if label_choice_a_impact:
		label_choice_a_impact.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if label_choice_b_text:
		label_choice_b_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if label_choice_b_impact:
		label_choice_b_impact.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if label_choice_c_text:
		label_choice_c_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if label_choice_c_impact:
		label_choice_c_impact.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if label_choice_d_text:
		label_choice_d_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if label_choice_d_impact:
		label_choice_d_impact.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if feedback_label:
		feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if game_over_reason:
		game_over_reason.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if victory_subtitle:
		victory_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Connect game manager signals
	game_manager.resources_changed.connect(_on_resources_changed)
	game_manager.event_presented.connect(_on_event_presented)
	game_manager.decision_applied.connect(_on_decision_applied)
	game_manager.harvest_matured.connect(_on_harvest_matured)
	game_manager.game_over.connect(_on_game_over)
	game_manager.game_won.connect(_on_game_won)

	# Connect buttons
	btn_choice_a.pressed.connect(_on_choice_a_pressed)
	btn_choice_b.pressed.connect(_on_choice_b_pressed)
	if btn_choice_c:
		btn_choice_c.pressed.connect(_on_choice_c_pressed)
	if btn_choice_d:
		btn_choice_d.pressed.connect(_on_choice_d_pressed)
		
	btn_restart_game_over.pressed.connect(_on_restart_pressed)
	btn_restart_victory.pressed.connect(_on_restart_pressed)

	# Initialize BadgeManager (autoload singleton)
	badge_manager = get_node_or_null("/root/BadgeManager")
	if badge_manager and badge_manager.has_signal("badge_unlocked"):
		if not badge_manager.badge_unlocked.is_connected(_on_badge_unlocked):
			badge_manager.badge_unlocked.connect(_on_badge_unlocked)

	# Initialize SpaceWeatherAPI (autoload singleton)
	var space_api = get_node_or_null("/root/SpaceWeatherAPI")
	if space_api and space_api.has_signal("live_data_updated"):
		if not space_api.live_data_updated.is_connected(_on_space_weather_updated):
			space_api.live_data_updated.connect(_on_space_weather_updated)


	if has_node("%BtnBadges"):
		var btn_b: Button = get_node("%BtnBadges")
		if not btn_b.pressed.is_connected(_on_badges_pressed):
			btn_b.pressed.connect(_on_badges_pressed)


	# Initialize Astrobot assets, idle animation, and click-to-talk
	_load_astrobot_assets()
	_start_astrobot_idle_animation()

	# Initialize physiological & critical audio
	_ensure_physiological_audio()
	_load_physiological_audio_assets()

	if btn_astrobot_avatar and not btn_astrobot_avatar.pressed.is_connected(_on_astrobot_avatar_pressed):
		btn_astrobot_avatar.pressed.connect(_on_astrobot_avatar_pressed)

	if btn_close_bubble and not btn_close_bubble.pressed.is_connected(_close_speech_bubble):
		btn_close_bubble.pressed.connect(_close_speech_bubble)

	if btn_bubble_hint and not btn_bubble_hint.pressed.is_connected(_on_bubble_hint_pressed):
		btn_bubble_hint.pressed.connect(_on_bubble_hint_pressed)

	if btn_bubble_encyclopedia_link and not btn_bubble_encyclopedia_link.pressed.is_connected(_on_bubble_encyclopedia_pressed):
		btn_bubble_encyclopedia_link.pressed.connect(_on_bubble_encyclopedia_pressed)

	start_event_simulation(default_mode)

func start_event_simulation(mode: String = "ALL") -> void:
	default_mode = mode
	_stop_physiological_audio()
	game_over_panel.visible = false
	victory_panel.visible = false
	feedback_panel.visible = false
	is_processing_choice = false
	
	# Ensure SpaceWeatherAPI has latest data for session
	var space_api = get_node_or_null("/root/SpaceWeatherAPI")
	if space_api and not space_api.is_live_data_available:
		space_api.fetch_live_space_weather()
	
	game_manager.start_game(60, 60, 60, 0.0, 80, 40, 60, mode)

func _on_space_weather_updated(_live_data: Dictionary) -> void:
	# If we are currently viewing a space weather event (1-8), reload the event view with live parameters
	if current_event_data and current_event_data.get("id", 0) <= 8 and not is_processing_choice:
		var ev_id = current_event_data.get("id", 0)
		var donki_events = DonkiEvents.get_all_events()
		for ev in donki_events:
			if ev.get("id", 0) == ev_id:
				_on_event_presented(ev, game_manager.current_event_index + 1, game_manager.events.size())
				break

func _on_event_presented(event_data: Dictionary, current_idx: int, total_count: int) -> void:
	current_event_data = event_data
	is_processing_choice = false
	
	var ev_id = event_data.get("id", current_idx)
	
	# Thematic Event Classification
	if ev_id >= 28:
		event_counter.text = "MARS BASE SURVIVAL • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(1.0, 0.35, 0.2)
	elif ev_id >= 25:
		event_counter.text = "CSA STEM SCIENCE QUIZ • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(0.9, 0.4, 1.0)
	elif ev_id == 20:
		event_counter.text = "MARS TREK EXPEDITION • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(1.0, 0.75, 0.2)
	elif ev_id >= 19:
		event_counter.text = "CSA FOOD & GREENHOUSE • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(0.4, 1.0, 0.3)
	elif ev_id >= 15:
		event_counter.text = "NASA RADLAB DOSIMETRY • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(1.0, 0.45, 0.25)
	elif ev_id >= 9:
		event_counter.text = "NASA OSDR ASTRONAUT HEALTH • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(0.2, 1.0, 0.6)
	else:
		event_counter.text = "NASA DONKI SPACE WEATHER • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(0, 0.85, 1.0)
		
	event_title.text = "%d. %s" % [ev_id, event_data.get("title", "Unknown Event")]
	event_scenario.text = event_data.get("scenario", "")
	
	# Update Astrobot Character Mood & Appearance
	var mood = AstrobotEventsData.get_mood(ev_id)
	if mood == "Unknown" or mood.is_empty():
		mood = "Optimal"
	_update_astrobot_mood(mood, ev_id)
	_close_speech_bubble()
	
	# Choice A Setup
	var choice_a = event_data.get("choice_a", {})
	label_choice_a_text.text = "A. %s" % choice_a.get("label", "Option A")
	var impact_a = game_manager.format_effects(choice_a.get("effects", {}))
	label_choice_a_impact.text = "[ Impact: %s ]" % impact_a
	
	# Choice B Setup
	var choice_b = event_data.get("choice_b", {})
	label_choice_b_text.text = "B. %s" % choice_b.get("label", "Option B")
	var impact_b = game_manager.format_effects(choice_b.get("effects", {}))
	label_choice_b_impact.text = "[ Impact: %s ]" % impact_b

	# Optional Choice C Setup (Events 19 & 20)
	if btn_choice_c:
		if event_data.has("choice_c"):
			var choice_c = event_data["choice_c"]
			label_choice_c_text.text = "C. %s" % choice_c.get("label", "Option C")
			var impact_c = game_manager.format_effects(choice_c.get("effects", {}))
			label_choice_c_impact.text = "[ Impact: %s ]" % impact_c
			btn_choice_c.visible = true
			btn_choice_c.disabled = false
		else:
			btn_choice_c.visible = false

	# Optional Choice D Setup (Event 20)
	if btn_choice_d:
		if event_data.has("choice_d"):
			var choice_d = event_data["choice_d"]
			label_choice_d_text.text = "D. %s" % choice_d.get("label", "Option D")
			var impact_d = game_manager.format_effects(choice_d.get("effects", {}))
			label_choice_d_impact.text = "[ Impact: %s ]" % impact_d
			btn_choice_d.visible = true
			btn_choice_d.disabled = false
		else:
			btn_choice_d.visible = false

	btn_choice_a.disabled = false
	btn_choice_b.disabled = false

	_animate_event_entrance()

func _on_resources_changed(resources: Dictionary, delta: Dictionary) -> void:
	var energy = resources.get("energy", 50)
	var oxygen = resources.get("oxygen", 50)
	var shield = resources.get("shield", 50)
	var radiation: float = float(resources.get("radiation", 0.0))
	var health = resources.get("health", 70)
	var food = resources.get("food", 30)
	var water = resources.get("water", 50)

	var tween = create_tween().set_parallel(true)
	tween.tween_property(energy_bar, "value", energy, 0.35)
	tween.tween_property(oxygen_bar, "value", oxygen, 0.35)
	tween.tween_property(shield_bar, "value", shield, 0.35)
	tween.tween_property(radiation_bar, "value", radiation, 0.35)
	
	if health_bar:
		tween.tween_property(health_bar, "value", health, 0.35)
	if food_bar:
		tween.tween_property(food_bar, "value", food, 0.35)
	if water_bar:
		tween.tween_property(water_bar, "value", water, 0.35)
	
	energy_val.text = "%d%%" % energy
	oxygen_val.text = "%d%%" % oxygen
	shield_val.text = "%d%%" % shield
	
	if is_equal_approx(radiation, round(radiation)):
		radiation_val.text = "%d mSv" % int(radiation)
	else:
		radiation_val.text = "%.1f mSv" % radiation
	
	if health_val:
		health_val.text = "%d%%" % health
	if food_val:
		food_val.text = "%d" % food
	if water_val:
		water_val.text = "%d%%" % water
	
	if radiation >= 80.0:
		rad_badge.text = "[ CRITICAL ]"
		rad_badge.modulate = Color(1.0, 0.2, 0.2)
	elif radiation >= 40.0:
		rad_badge.text = "[ ELEVATED ]"
		rad_badge.modulate = Color(1.0, 0.65, 0.1)
	else:
		rad_badge.text = "[ NOMINAL ]"
		rad_badge.modulate = Color(0.2, 1.0, 0.4)

	# Monitor physiological sound effects
	var delta_health = delta.get("health", 0)
	var delta_oxygen = delta.get("oxygen", 0)

	# Low Health (<= 25%) or heavy hit
	if health <= 25 or (delta_health <= -20 and health <= 40):
		_start_heartbeat()
	elif health > 25:
		_stop_heartbeat(true)

	# Low Oxygen (<= 25%) or sharp drop
	if oxygen <= 25 or (delta_oxygen <= -20 and oxygen <= 40):
		_start_breathing()
	elif oxygen > 25:
		_stop_breathing(true)

func _on_choice_a_pressed() -> void:
	if is_processing_choice: return
	_disable_buttons()
	game_manager.choose_option("A")

func _on_choice_b_pressed() -> void:
	if is_processing_choice: return
	_disable_buttons()
	game_manager.choose_option("B")

func _on_choice_c_pressed() -> void:
	if is_processing_choice: return
	_disable_buttons()
	game_manager.choose_option("C")

func _on_choice_d_pressed() -> void:
	if is_processing_choice: return
	_disable_buttons()
	game_manager.choose_option("D")

func _disable_buttons() -> void:
	is_processing_choice = true
	btn_choice_a.disabled = true
	btn_choice_b.disabled = true
	if btn_choice_c: btn_choice_c.disabled = true
	if btn_choice_d: btn_choice_d.disabled = true

func _on_decision_applied(choice_label: String, delta: Dictionary, outcome_message: String) -> void:
	feedback_label.text = outcome_message
	feedback_panel.visible = true
	feedback_panel.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(feedback_panel, "modulate:a", 1.0, 0.2)
	tween.tween_interval(1.3)
	tween.tween_property(feedback_panel, "modulate:a", 0.0, 0.25)
	await tween.finished
	feedback_panel.visible = false
	
	# Check badge conditions after each decision
	_check_badges_after_decision()

func _on_harvest_matured(crop_name: String, food_amount: int) -> void:
	print("🌱 Greenhouse Harvest Event: %s produced +%d Food" % [crop_name, food_amount])

func _on_game_over(reason: String, stats: Dictionary) -> void:
	# Immediately stop looping physiological audio and play failure sound
	_play_mission_failed_sound()

	game_over_reason.text = reason
	var rad_str = "%.1f" % stats.radiation if not is_equal_approx(stats.radiation, round(stats.radiation)) else "%d" % int(stats.radiation)
	game_over_stats.text = "FINAL SHIP & CREW STATUS:\n• Health: %d%%  |  Energy: %d%%  |  Oxygen: %d%%\n• Shield: %d%%  |  Radiation: %s / %.0f mSv  |  Food: %d  |  Water: %d%%\n• Events survived: %d / %d (%s mode)" % [
		stats.get("health", 0), stats.energy, stats.oxygen, stats.shield, rad_str, stats.radiation_limit,
		stats.get("food", 0), stats.get("water", 0), stats.events_completed, stats.total_events, stats.get("game_mode", "ALL")
	]
	game_over_panel.visible = true
	game_over_panel.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(game_over_panel, "modulate:a", 1.0, 0.4)

func _on_game_won(stats: Dictionary) -> void:
	# Immediately stop looping physiological audio
	_stop_physiological_audio()

	if victory_title:
		victory_title.text = "MISSION SUCCESSFUL • MARS EXPEDITION CONQUERED"
	if victory_subtitle:
		victory_subtitle.text = "Commander, the Astro-Care crew has survived all 30 NASA & CSA deep space events!"
		
	var rad_str = "%.1f" % stats.radiation if not is_equal_approx(stats.radiation, round(stats.radiation)) else "%d" % int(stats.radiation)
	victory_stats.text = "MISSION COMPLETION TELEMETRY:\n• Crew Health: %d%%\n• Remaining Energy: %d%%  |  Oxygen: %d%%  |  Shield: %d%%\n• Cumulative Radiation: %s mSv (Limit: %.0f mSv)\n• Outpost Supplies: Food %d  |  Water %d%%  |  Science Score: %d\n• Completed all %d mission events in %s mode!" % [
		stats.get("health", 0), stats.energy, stats.oxygen, stats.shield, rad_str, stats.radiation_limit,
		stats.get("food", 0), stats.get("water", 0), stats.get("score", 0), stats.total_events, stats.get("game_mode", "ALL")
	]
	victory_rating.text = "COMMANDER EVALUATION:\n%s" % game_manager.calculate_rating()
	victory_panel.visible = true
	victory_panel.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(victory_panel, "modulate:a", 1.0, 0.4)

func _on_restart_pressed() -> void:
	_stop_physiological_audio()
	# Reset badge manager on restart
	if badge_manager and badge_manager.has_method("reset"):
		badge_manager.reset()
	start_event_simulation(default_mode)

func _on_encyclopedia_pressed() -> void:
	if encyclopedia_instance == null or not is_instance_valid(encyclopedia_instance):
		encyclopedia_instance = encyclopedia_scene.instantiate()
		encyclopedia_instance.visible = false
		add_child(encyclopedia_instance)
	encyclopedia_instance.current_index = 0
	encyclopedia_instance._display_card_data(0)
	encyclopedia_instance.open()

func _on_badges_pressed() -> void:
	if badges_instance == null or not is_instance_valid(badges_instance):
		badges_instance = badges_scene.instantiate()
		add_child(badges_instance)
	var stats = game_manager.get_stats() if game_manager else {}
	var history = game_manager.decision_history if game_manager else []
	badges_instance.open(stats, history)


func _load_astrobot_assets() -> void:
	# Textures (load clean dedicated files or fallback to existing assets)
	if ResourceLoader.exists("res://assets/images/astrobot_optimal.png"):
		tex_optimal = load("res://assets/images/astrobot_optimal.png")
	elif ResourceLoader.exists("res://assets/images/Sans_titre__9_-removebg-preview.png"):
		tex_optimal = load("res://assets/images/Sans_titre__9_-removebg-preview.png")

	if ResourceLoader.exists("res://assets/images/astrobot_critical.png"):
		tex_critical = load("res://assets/images/astrobot_critical.png")
	elif ResourceLoader.exists("res://assets/images/Sans_titre__10_-removebg-preview.png"):
		tex_critical = load("res://assets/images/Sans_titre__10_-removebg-preview.png")

	if ResourceLoader.exists("res://assets/images/astrobot_warning.png"):
		tex_warning = load("res://assets/images/astrobot_warning.png")
	elif ResourceLoader.exists("res://assets/images/Sans_titre__11_-removebg-preview_1.png"):
		tex_warning = load("res://assets/images/Sans_titre__11_-removebg-preview_1.png")

	if ResourceLoader.exists("res://assets/images/astrobot_science.png"):
		tex_science = load("res://assets/images/astrobot_science.png")
	elif ResourceLoader.exists("res://assets/images/Pixel_Robot_Expression_Sprite_Set-removebg-preview.png"):
		tex_science = load("res://assets/images/Pixel_Robot_Expression_Sprite_Set-removebg-preview.png")

	# Audio (load clean .wav or fallback to existing sound effects)
	if ResourceLoader.exists("res://assets/audios/alert_red.wav"):
		sfx_alert_red = load("res://assets/audios/alert_red.wav")
	elif ResourceLoader.exists("res://assets/audio/sound effects/Error.mp3"):
		sfx_alert_red = load("res://assets/audio/sound effects/Error.mp3")

	if ResourceLoader.exists("res://assets/audios/warning_yellow.wav"):
		sfx_warning_yellow = load("res://assets/audios/warning_yellow.wav")
	elif ResourceLoader.exists("res://assets/audio/sound effects/pop up bot.mp3"):
		sfx_warning_yellow = load("res://assets/audio/sound effects/pop up bot.mp3")

	if ResourceLoader.exists("res://assets/audios/optimal_beep.wav"):
		sfx_optimal_beep = load("res://assets/audios/optimal_beep.wav")
	elif ResourceLoader.exists("res://assets/audio/sound effects/success.mp3.mp3"):
		sfx_optimal_beep = load("res://assets/audio/sound effects/success.mp3.mp3")

	if ResourceLoader.exists("res://assets/audios/astrobot_speak.wav"):
		sfx_astrobot_speak = load("res://assets/audios/astrobot_speak.wav")
	elif ResourceLoader.exists("res://assets/audio/sound effects/typing.mp3"):
		sfx_astrobot_speak = load("res://assets/audio/sound effects/typing.mp3")

func _start_astrobot_idle_animation() -> void:
	if not avatar_frame:
		return
	var base_pos_y: float = avatar_frame.position.y
	var tween = create_tween().set_loops()
	tween.tween_property(avatar_frame, "position:y", base_pos_y - 7.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(avatar_frame, "position:y", base_pos_y, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _update_astrobot_mood(mood: String, ev_id: int) -> void:
	active_mood = mood
	var mood_color := Color(0, 0.85, 1)
	var badge_text := "[ OPTIMAL ]"
	var current_tex: Texture2D = tex_optimal

	match mood:
		"Critical":
			current_tex = tex_critical
			mood_color = Color(1.0, 0.28, 0.28) # Red alarm
			badge_text = "[ CRITICAL ALARM ]"
		"Warning":
			current_tex = tex_warning
			mood_color = Color(1.0, 0.82, 0.2) # Yellow caution
			badge_text = "[ HAZARD WARNING ]"
		"Optimal":
			current_tex = tex_optimal
			mood_color = Color(0.25, 0.95, 0.55) # Green smile
			badge_text = "[ OPTIMAL STATUS ]"
		"Science":
			current_tex = tex_science
			mood_color = Color(0.1, 0.88, 1.0) # Blue analytical
			badge_text = "[ SCIENTIFIC QUERY ]"

	if btn_astrobot_avatar and current_tex:
		btn_astrobot_avatar.texture_normal = current_tex
		btn_astrobot_avatar.texture_hover = current_tex
		btn_astrobot_avatar.texture_pressed = current_tex

	if astrobot_mood_badge:
		astrobot_mood_badge.text = badge_text
		astrobot_mood_badge.add_theme_color_override("font_color", mood_color)

	if bubble_title:
		bubble_title.text = "🤖 ASTRO-BOT • %s" % badge_text
		bubble_title.add_theme_color_override("font_color", mood_color)

	# Update stylebox borders to glow in matching mood color
	if avatar_frame:
		var style = avatar_frame.get_theme_stylebox("panel")
		if style is StyleBoxFlat:
			var new_style: StyleBoxFlat = style.duplicate()
			new_style.border_color = mood_color
			avatar_frame.add_theme_stylebox_override("panel", new_style)

	if speech_bubble:
		var style = speech_bubble.get_theme_stylebox("panel")
		if style is StyleBoxFlat:
			var new_style: StyleBoxFlat = style.duplicate()
			new_style.border_color = mood_color
			new_style.shadow_color = Color(mood_color.r, mood_color.g, mood_color.b, 0.25)
			speech_bubble.add_theme_stylebox_override("panel", new_style)

func _on_astrobot_avatar_pressed() -> void:
	if not speech_bubble:
		return

	# If currently typing, click instantly completes the full dialogue
	if is_typewriting:
		_finish_typewriting()
		return

	# If already open and done, click closes it
	if speech_bubble.visible:
		_close_speech_bubble()
		return

	# Open and type out active event dialogue
	var ev_id: int = current_event_data.get("id", 1)
	var dialogue: String = AstrobotEventsData.get_dialogue(ev_id)
	if dialogue.is_empty():
		dialogue = current_event_data.get("bot_advice", "Commander, telemetry is standing by.")
	_display_speech_bubble(dialogue)

func _display_speech_bubble(text_to_speak: String) -> void:
	if not speech_bubble:
		return

	current_dialogue_target = text_to_speak
	speech_bubble.visible = true
	speech_bubble.modulate.a = 0.0

	# Hide hint panel on fresh open
	if hint_panel:
		hint_panel.visible = false

	# Pre-load hint text for current event
	var ev_id: int = current_event_data.get("id", 1)
	if hint_text:
		var h = AstrobotEventsData.get_hint(ev_id)
		hint_text.text = "💡 %s" % h if not h.is_empty() else "💡 Hint: Monitor resources closely!"

	# Instantly play mood popup sound effect
	_play_mood_popup_sound(active_mood)

	# Reactive bounce animation on avatar frame
	if avatar_frame:
		var bounce = create_tween()
		bounce.tween_property(avatar_frame, "scale", Vector2(0.94, 0.94), 0.08)
		bounce.tween_property(avatar_frame, "scale", Vector2(1.0, 1.0), 0.12)

	# Fade in speech bubble
	var tween = create_tween()
	tween.tween_property(speech_bubble, "modulate:a", 1.0, 0.18)

	# Start character-by-character typewriter effect
	_start_typewriter(text_to_speak)

func _play_mood_popup_sound(mood: String) -> void:
	if not audio_mood_popup:
		return
	var stream: AudioStream = null
	match mood:
		"Critical":
			stream = sfx_alert_red
		"Warning":
			stream = sfx_warning_yellow
		"Optimal":
			stream = sfx_optimal_beep
		"Science":
			stream = sfx_optimal_beep if sfx_optimal_beep else sfx_warning_yellow
		_:
			stream = sfx_optimal_beep

	if stream:
		audio_mood_popup.stream = stream
		audio_mood_popup.play()

func _start_typewriter(target_text: String) -> void:
	if not bubble_text:
		return
	if typewriter_tween:
		typewriter_tween.kill()

	bubble_text.text = ""
	is_typewriting = true

	typewriter_tween = create_tween()
	var char_duration := 0.024
	var text_len := target_text.length()

	for i in range(1, text_len + 1):
		typewriter_tween.tween_callback(func():
			if not is_typewriting:
				return
			bubble_text.text = target_text.substr(0, i)
			# Play typing sound periodically
			if i % 3 == 0 and audio_typewriter and sfx_astrobot_speak:
				audio_typewriter.stream = sfx_astrobot_speak
				audio_typewriter.pitch_scale = randf_range(0.95, 1.1)
				audio_typewriter.play()
		)
		typewriter_tween.tween_interval(char_duration)

	typewriter_tween.finished.connect(func():
		is_typewriting = false
		_stop_all_audio()
	)

func _finish_typewriting() -> void:
	if typewriter_tween:
		typewriter_tween.kill()
	is_typewriting = false
	_stop_all_audio()
	if bubble_text:
		bubble_text.text = current_dialogue_target

func _close_speech_bubble() -> void:
	if not speech_bubble or not speech_bubble.visible:
		return
	_stop_all_audio()
	if typewriter_tween:
		typewriter_tween.kill()
	is_typewriting = false
	if hint_panel:
		hint_panel.visible = false
	var tween = create_tween()
	tween.tween_property(speech_bubble, "modulate:a", 0.0, 0.15)
	await tween.finished
	speech_bubble.visible = false

func _on_bubble_hint_pressed() -> void:
	if not hint_panel:
		return
	var ev_id: int = current_event_data.get("id", 1)
	var hint: String = AstrobotEventsData.get_hint(ev_id)
	if hint.is_empty():
		hint = "💡 Hint: Monitor your resources closely, Commander!"
	if hint_text:
		hint_text.text = "💡 %s" % hint

	hint_panel.visible = not hint_panel.visible
	if hint_panel.visible:
		hint_panel.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(hint_panel, "modulate:a", 1.0, 0.2)

func _on_bubble_encyclopedia_pressed() -> void:
	_on_encyclopedia_pressed()

func _stop_all_audio() -> void:
	if audio_typewriter and audio_typewriter.playing:
		audio_typewriter.stop()
	if audio_mood_popup and audio_mood_popup.playing:
		audio_mood_popup.stop()

# ─── Physiological & Mission Failed Audio Systems ──────────────────

func _ensure_physiological_audio() -> void:
	if heartbeat_audio == null:
		heartbeat_audio = get_node_or_null("%HeartbeatAudio")
	if heartbeat_audio == null:
		heartbeat_audio = AudioStreamPlayer.new()
		heartbeat_audio.name = "HeartbeatAudio"
		add_child(heartbeat_audio)
	if not heartbeat_audio.finished.is_connected(_on_heartbeat_finished):
		heartbeat_audio.finished.connect(_on_heartbeat_finished)

	if breathing_audio == null:
		breathing_audio = get_node_or_null("%BreathingAudio")
	if breathing_audio == null:
		breathing_audio = AudioStreamPlayer.new()
		breathing_audio.name = "BreathingAudio"
		add_child(breathing_audio)
	if not breathing_audio.finished.is_connected(_on_breathing_finished):
		breathing_audio.finished.connect(_on_breathing_finished)

	if failure_audio == null:
		failure_audio = get_node_or_null("%FailureAudio")
	if failure_audio == null:
		failure_audio = AudioStreamPlayer.new()
		failure_audio.name = "FailureAudio"
		add_child(failure_audio)

func _load_physiological_audio_assets() -> void:
	if ResourceLoader.exists("res://assets/audio/sound effects/heartbeat.mp3.mp3"):
		sfx_heartbeat = load("res://assets/audio/sound effects/heartbeat.mp3.mp3")
	elif ResourceLoader.exists("res://assets/audio/heartbeat.mp3.mp3"):
		sfx_heartbeat = load("res://assets/audio/heartbeat.mp3.mp3")

	if ResourceLoader.exists("res://assets/audio/sound effects/breathing.mp3.mp3"):
		sfx_breathing = load("res://assets/audio/sound effects/breathing.mp3.mp3")
	elif ResourceLoader.exists("res://assets/audio/breathing.mp3.mp3"):
		sfx_breathing = load("res://assets/audio/breathing.mp3.mp3")

	if ResourceLoader.exists("res://assets/audio/error.mp3.mp3"):
		sfx_failure = load("res://assets/audio/error.mp3.mp3")
	elif ResourceLoader.exists("res://assets/audio/sound effects/Error.mp3"):
		sfx_failure = load("res://assets/audio/sound effects/Error.mp3")
	elif ResourceLoader.exists("res://assets/audio/sound effects/losing.mp3.mp3"):
		sfx_failure = load("res://assets/audio/sound effects/losing.mp3.mp3")

	if sfx_heartbeat is AudioStreamMP3:
		(sfx_heartbeat as AudioStreamMP3).loop = true
	if sfx_breathing is AudioStreamMP3:
		(sfx_breathing as AudioStreamMP3).loop = true

func _on_heartbeat_finished() -> void:
	if is_heartbeat_playing and heartbeat_audio and sfx_heartbeat:
		heartbeat_audio.play()

func _on_breathing_finished() -> void:
	if is_breathing_playing and breathing_audio and sfx_breathing:
		breathing_audio.play()

func _start_heartbeat() -> void:
	if not heartbeat_audio or not sfx_heartbeat:
		return
	if is_heartbeat_playing and heartbeat_audio.playing:
		return
	is_heartbeat_playing = true
	if heartbeat_tween:
		heartbeat_tween.kill()
	heartbeat_audio.stream = sfx_heartbeat
	heartbeat_audio.volume_db = -36.0
	heartbeat_audio.play()
	heartbeat_tween = create_tween()
	heartbeat_tween.tween_property(heartbeat_audio, "volume_db", -4.0, 0.8)

func _stop_heartbeat(smooth: bool = true) -> void:
	if not is_heartbeat_playing and (heartbeat_audio == null or not heartbeat_audio.playing):
		return
	is_heartbeat_playing = false
	if heartbeat_tween:
		heartbeat_tween.kill()
	if not heartbeat_audio or not heartbeat_audio.playing:
		return
	if smooth:
		heartbeat_tween = create_tween()
		heartbeat_tween.tween_property(heartbeat_audio, "volume_db", -40.0, 0.8)
		heartbeat_tween.tween_callback(func():
			if not is_heartbeat_playing and heartbeat_audio:
				heartbeat_audio.stop()
		)
	else:
		heartbeat_audio.stop()

func _start_breathing() -> void:
	if not breathing_audio or not sfx_breathing:
		return
	if is_breathing_playing and breathing_audio.playing:
		return
	is_breathing_playing = true
	if breathing_tween:
		breathing_tween.kill()
	breathing_audio.stream = sfx_breathing
	breathing_audio.volume_db = -36.0
	breathing_audio.play()
	breathing_tween = create_tween()
	breathing_tween.tween_property(breathing_audio, "volume_db", -5.0, 0.8)

func _stop_breathing(smooth: bool = true) -> void:
	if not is_breathing_playing and (breathing_audio == null or not breathing_audio.playing):
		return
	is_breathing_playing = false
	if breathing_tween:
		breathing_tween.kill()
	if not breathing_audio or not breathing_audio.playing:
		return
	if smooth:
		breathing_tween = create_tween()
		breathing_tween.tween_property(breathing_audio, "volume_db", -40.0, 0.8)
		breathing_tween.tween_callback(func():
			if not is_breathing_playing and breathing_audio:
				breathing_audio.stop()
		)
	else:
		breathing_audio.stop()

func _stop_physiological_audio() -> void:
	_stop_heartbeat(false)
	_stop_breathing(false)

func _play_mission_failed_sound() -> void:
	_stop_physiological_audio()
	if failure_audio and sfx_failure:
		failure_audio.stream = sfx_failure
		failure_audio.volume_db = -2.0
		failure_audio.play()


func _animate_event_entrance() -> void:
	if root_control:
		root_control.modulate.a = 0.85
		var tween = create_tween()
		tween.tween_property(root_control, "modulate:a", 1.0, 0.2)

# ─── Badge System Integration ──────────────────────────────────────

var _last_choice_key: String = ""

func _check_badges_after_decision() -> void:
	if not badge_manager or not game_manager:
		return
	var ev_id: int = current_event_data.get("id", 0)
	var stats: Dictionary = game_manager.get_stats()
	var history: Array[Dictionary] = game_manager.decision_history
	# Determine the last choice key from history
	var choice_key: String = "A"
	if history.size() > 0:
		choice_key = history[-1].get("choice_key", "A")
	badge_manager.on_decision_made(ev_id, choice_key, stats, history)

func _on_badge_unlocked(badge_id: String, badge_title: String, badge_icon: String) -> void:
	# Show Astrobot celebration popup in the speech bubble
	var celebrate_text = "🏆 Congrats, Commander! New Badge Unlocked!\n\n%s %s\n\nYou've earned a new Expedition Award!" % [badge_icon, badge_title]
	_update_astrobot_mood("Optimal", current_event_data.get("id", 1))
	_display_speech_bubble(celebrate_text)

	# If badges modal is open, animate the unlock card
	if badges_instance and is_instance_valid(badges_instance) and badges_instance.visible:
		badges_instance.animate_unlock_card(badge_id)
