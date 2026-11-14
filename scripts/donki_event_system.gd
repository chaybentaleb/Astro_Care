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
@onready var donki_badge: Label = %DonkiBadge
@onready var event_title: Label = %EventTitle
@onready var event_scenario: Label = %EventScenario

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
var current_event_data: Dictionary = {}
var is_processing_choice: bool = false
var default_mode: String = "ALL"

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

	start_event_simulation(default_mode)

func start_event_simulation(mode: String = "ALL") -> void:
	default_mode = mode
	game_over_panel.visible = false
	victory_panel.visible = false
	feedback_panel.visible = false
	is_processing_choice = false
	
	game_manager.start_game(60, 60, 60, 0.0, 80, 40, 60, mode)

func _on_event_presented(event_data: Dictionary, current_idx: int, total_count: int) -> void:
	current_event_data = event_data
	is_processing_choice = false
	
	var ev_id = event_data.get("id", current_idx)
	
	# Thematic Event Classification
	if ev_id >= 28:
		event_counter.text = "MARS BASE SURVIVAL • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(1.0, 0.35, 0.2) # Deep Mars Red
		donki_badge.text = event_data.get("code", "MARS-SURV")
		donki_badge.modulate = Color(1.0, 0.5, 0.2)
	elif ev_id >= 25:
		event_counter.text = "CSA STEM SCIENCE QUIZ • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(0.9, 0.4, 1.0) # STEM Violet
		donki_badge.text = event_data.get("code", "STEM-QUIZ")
		donki_badge.modulate = Color(0.6, 0.9, 1.0)
	elif ev_id == 20:
		event_counter.text = "MARS TREK EXPEDITION • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(1.0, 0.75, 0.2) # Explorer Gold
		donki_badge.text = event_data.get("code", "MARS-TREK-LOC-20")
		donki_badge.modulate = Color(1.0, 0.9, 0.3)
	elif ev_id >= 19:
		event_counter.text = "CSA FOOD & GREENHOUSE • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(0.4, 1.0, 0.3) # Flora Green
		donki_badge.text = event_data.get("csa_code", "CSA GREENHOUSE")
		donki_badge.modulate = Color(1.0, 0.9, 0.3)
	elif ev_id >= 15:
		event_counter.text = "NASA RADLAB DOSIMETRY • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(1.0, 0.45, 0.25)
		donki_badge.text = event_data.get("radlab_code", "RADLAB DOSIMETRY")
		donki_badge.modulate = Color(1.0, 0.8, 0.2)
	elif ev_id >= 9:
		event_counter.text = "NASA OSDR ASTRONAUT HEALTH • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(0.2, 1.0, 0.6)
		donki_badge.text = event_data.get("osdr_code", "OSDR BIOMEDICAL")
		donki_badge.modulate = Color(0.3, 0.9, 1.0)
	else:
		event_counter.text = "NASA DONKI SPACE WEATHER • EVENT %d OF %d" % [current_idx, total_count]
		event_counter.modulate = Color(0, 0.85, 1.0)
		donki_badge.text = event_data.get("donki_code", "DONKI ALERT")
		donki_badge.modulate = Color(1.0, 0.6, 0.2)
		
	event_title.text = "%d. %s" % [ev_id, event_data.get("title", "Unknown Event")]
	event_scenario.text = event_data.get("scenario", "")
	
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

func _on_harvest_matured(crop_name: String, food_amount: int) -> void:
	print("🌱 Greenhouse Harvest Event: %s produced +%d Food" % [crop_name, food_amount])

func _on_game_over(reason: String, stats: Dictionary) -> void:
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
	start_event_simulation(default_mode)

func _on_encyclopedia_pressed() -> void:
	# TODO: Connect Encyclopedia Flying Cards scene here
	pass

func _on_badges_pressed() -> void:
	# TODO: Connect Badges system modal here
	pass


func _animate_event_entrance() -> void:
	if root_control:
		root_control.modulate.a = 0.85
		var tween = create_tween()
		tween.tween_property(root_control, "modulate:a", 1.0, 0.2)
