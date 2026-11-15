class_name GameManager
extends Node

const DonkiEventsClass = preload("res://scripts/donki_events.gd")
const OsdrEventsClass = preload("res://scripts/osdr_events.gd")
const RadLabEventsClass = preload("res://scripts/radlab_events.gd")
const CsaEventsClass = preload("res://scripts/csa_events.gd")
const MarsStemEventsClass = preload("res://scripts/mars_stem_events.gd")

signal resources_changed(resources: Dictionary, delta: Dictionary)
signal event_presented(event_data: Dictionary, current_index: int, total_count: int)
signal decision_applied(choice_label: String, delta: Dictionary, outcome_message: String)
signal harvest_matured(crop_name: String, food_amount: int)
signal game_over(reason: String, stats: Dictionary)
signal game_won(stats: Dictionary)

const MAX_ENERGY: int = 100
const MAX_OXYGEN: int = 100
const MAX_SHIELD: int = 100
const MAX_HEALTH: int = 100
const MAX_FOOD: int = 100
const MAX_WATER: int = 100
const MAX_RADIATION_LIMIT: float = 100.0 # In mSv, cumulative lethal dose threshold

# Resource states
var energy: int = 50
var oxygen: int = 50
var shield: int = 50
var radiation: float = 0.0 # Cumulative in mSv
var health: int = 70       # Crew physical & psychological health (0 - 100)
var food: int = 30         # NASA-grade food rations (0 - 100)
var water: int = 50        # Potable water reserve (0 - 100)
var mission_score: int = 0 # Scientific discovery score

# Event 20 Mars Base persistent per-turn modifiers
var base_water_per_turn: int = 0
var base_energy_per_turn: int = 0
var base_score_per_turn: int = 0
var base_rad_multiplier: float = 1.0

var current_event_index: int = 0
var events: Array[Dictionary] = []
var decision_history: Array[Dictionary] = []
var pending_harvests: Array[Dictionary] = []
var is_game_active: bool = false
var game_mode: String = "ALL" # "ALL", "DONKI", "OSDR", "RADLAB", "CSA", "MARS"

func _ready() -> void:
	load_events(game_mode)

func load_events(mode: String = "ALL") -> void:
	game_mode = mode
	events.clear()
	var donki = DonkiEventsClass.get_all_events()     # 1 - 8
	var osdr = OsdrEventsClass.get_all_events()       # 9 - 14
	var radlab = RadLabEventsClass.get_all_events()   # 15 - 18
	var csa = CsaEventsClass.get_all_events()         # 19, 21 - 24
	var mars = MarsStemEventsClass.get_all_events()   # 20, 25 - 30
	
	match mode:
		"DONKI":
			events.append_array(donki)
		"OSDR":
			events.append_array(osdr)
		"RADLAB":
			events.append_array(radlab)
		"CSA":
			events.append_array(csa)
		"MARS":
			events.append_array(mars)
		_:
			# Build complete 30-event storyline in exact numerical order:
			# 1 to 8: DONKI Space Weather
			events.append_array(donki)
			# 9 to 14: OSDR Astronaut Health
			events.append_array(osdr)
			# 15 to 18: RadLab Dosimetry
			events.append_array(radlab)
			# 19: CSA Grow Food (Pick a crop)
			events.append(csa[0])
			# 20: Mars Map Selection
			events.append(mars[0])
			# 21 to 24: CSA Water, Mold, Food, Mars Potatoes
			for i in range(1, csa.size()):
				events.append(csa[i])
			# 25 to 30: CSA STEM Quizzes & Mars Base Survival
			for i in range(1, mars.size()):
				events.append(mars[i])

func start_game(
	start_energy: int = 60,
	start_oxygen: int = 60,
	start_shield: int = 60,
	start_rad: float = 0.0,
	start_health: int = 80,
	start_food: int = 40,
	start_water: int = 60,
	mode: String = "ALL"
) -> void:
	load_events(mode)
	energy = start_energy
	oxygen = start_oxygen
	shield = start_shield
	radiation = start_rad
	health = start_health
	food = start_food
	water = start_water
	mission_score = 0
	
	base_water_per_turn = 0
	base_energy_per_turn = 0
	base_score_per_turn = 0
	base_rad_multiplier = 1.0
	
	current_event_index = 0
	decision_history.clear()
	pending_harvests.clear()
	is_game_active = true
	
	resources_changed.emit(get_resources_dict(), {})
	present_current_event()

func present_current_event() -> void:
	if current_event_index < events.size():
		event_presented.emit(events[current_event_index], current_event_index + 1, events.size())
	else:
		_trigger_victory()

func choose_option(choice_key: String) -> void:
	if not is_game_active or current_event_index >= events.size():
		return
		
	var current_event = events[current_event_index]
	var key_upper = choice_key.to_upper()
	var choice_data: Dictionary
	
	if key_upper == "A":
		choice_data = current_event.get("choice_a", {})
	elif key_upper == "B":
		choice_data = current_event.get("choice_b", {})
	elif key_upper == "C":
		choice_data = current_event.get("choice_c", {})
	elif key_upper == "D":
		choice_data = current_event.get("choice_d", {})
	else:
		choice_data = current_event.get("choice_a", {})
		
	var effects: Dictionary = choice_data.get("effects", {})
	
	# Apply immediate resource impacts
	var delta_energy: int = effects.get("energy", 0)
	var delta_oxygen: int = effects.get("oxygen", 0)
	var delta_shield: int = effects.get("shield", 0)
	var delta_rad: float = float(effects.get("radiation", 0.0)) * base_rad_multiplier
	var delta_health: int = effects.get("health", 0)
	var delta_food: int = effects.get("food", 0)
	var delta_water: int = effects.get("water", 0)
	
	energy = clampi(energy + delta_energy, 0, MAX_ENERGY)
	oxygen = clampi(oxygen + delta_oxygen, 0, MAX_OXYGEN)
	shield = clampi(shield + delta_shield, 0, MAX_SHIELD)
	radiation = maxf(0.0, radiation + delta_rad)
	health = clampi(health + delta_health, 0, MAX_HEALTH)
	food = clampi(food + delta_food, 0, MAX_FOOD)
	water = clampi(water + delta_water, 0, MAX_WATER)
	
	# Register Mars Base persistent modifiers (Event 20)
	if effects.has("water_per_turn"):
		base_water_per_turn = effects["water_per_turn"]
	if effects.has("energy_per_turn"):
		base_energy_per_turn = effects["energy_per_turn"]
	if effects.has("score_per_turn"):
		base_score_per_turn = effects["score_per_turn"]
	if effects.has("radiation_multiplier"):
		base_rad_multiplier = effects["radiation_multiplier"]
		
	# Apply passive per-turn bonuses from Mars Base
	water = clampi(water + base_water_per_turn, 0, MAX_WATER)
	energy = clampi(energy + base_energy_per_turn, 0, MAX_ENERGY)
	mission_score += base_score_per_turn
	
	# Process existing pending crop harvests from previous turns
	var mature_harvests: Array[Dictionary] = _tick_pending_harvests()
	for h in mature_harvests:
		food = clampi(food + h["food_amount"], 0, MAX_FOOD)
		harvest_matured.emit(h["crop_name"], h["food_amount"])

	# Register delayed crop harvest if planted this turn (e.g. Event 19)
	if effects.has("delayed_food") and effects.has("delay_turns"):
		pending_harvests.append({
			"turns_remaining": int(effects["delay_turns"]),
			"food_amount": int(effects["delayed_food"]),
			"crop_name": choice_data.get("label", "Greenhouse Crop")
		})
	
	var delta_dict = {
		"energy": delta_energy,
		"oxygen": delta_oxygen,
		"shield": delta_shield,
		"radiation": delta_rad,
		"health": delta_health,
		"food": delta_food,
		"water": delta_water
	}
	
	decision_history.append({
		"event_id": current_event["id"],
		"event_title": current_event["title"],
		"choice_key": choice_key,
		"choice_label": choice_data.get("label", ""),
		"delta": delta_dict
	})
	
	resources_changed.emit(get_resources_dict(), delta_dict)
	
	var impact_summary = format_effects(effects)
	var outcome_msg = "Command executed: Choice %s ('%s')\n[ %s ]" % [key_upper, choice_data.get("label", ""), impact_summary]
	for h in mature_harvests:
		outcome_msg += "\n🌱 HARVEST READY: %s generated +%d Food!" % [h["crop_name"], h["food_amount"]]
	if base_water_per_turn > 0:
		outcome_msg += "\n💧 Base Ice Harvester: +%d Water this sol!" % base_water_per_turn
		
	decision_applied.emit(choice_data.get("label", ""), delta_dict, outcome_msg)
	
	# Check survival failure conditions
	if not _check_game_over_conditions():
		current_event_index += 1
		if current_event_index < events.size():
			present_current_event()
		else:
			_trigger_victory()

func _tick_pending_harvests() -> Array[Dictionary]:
	var matured: Array[Dictionary] = []
	var still_growing: Array[Dictionary] = []
	for p in pending_harvests:
		p["turns_remaining"] -= 1
		if p["turns_remaining"] <= 0:
			matured.append(p)
		else:
			still_growing.append(p)
	pending_harvests = still_growing
	return matured

func format_effects(effects: Dictionary) -> String:
	return MarsStemEventsClass.format_effects(effects)

func _check_game_over_conditions() -> bool:
	var stats = get_stats()
	if energy <= 0:
		is_game_active = false
		game_over.emit("CRITICAL FAILURE: Power grid completely depleted! The Astro-Care went dark in the void.", stats)
		return true
	if oxygen <= 0:
		is_game_active = false
		game_over.emit("CRITICAL FAILURE: Atmospheric oxygen exhausted! Life support systems have shut down.", stats)
		return true
	if shield <= 0 and current_event_index < 8:
		# Shield failure fatal during space weather
		is_game_active = false
		game_over.emit("CRITICAL FAILURE: Deflector shields destroyed! Space weather sheared through the outer hull.", stats)
		return true
	if radiation >= MAX_RADIATION_LIMIT:
		is_game_active = false
		game_over.emit("LETHAL DOSE: Radiation exposure reached %.1f mSv! Exceeded critical safety limit of %.0f mSv." % [radiation, MAX_RADIATION_LIMIT], stats)
		return true
	if health <= 0:
		is_game_active = false
		game_over.emit("MEDICAL FATALITY: Astronaut health collapsed! The crew is non-functional.", stats)
		return true
	if food <= 0:
		is_game_active = false
		game_over.emit("CRITICAL SHORTAGE: Food rations completely exhausted! Crew starved on Mars.", stats)
		return true
	if water <= 0:
		is_game_active = false
		game_over.emit("CRITICAL DEHYDRATION: Potable water exhausted! Station life support cannot sustain crew.", stats)
		return true
	return false

func _trigger_victory() -> void:
	is_game_active = false
	game_won.emit(get_stats())

func get_resources_dict() -> Dictionary:
	return {
		"energy": energy,
		"oxygen": oxygen,
		"shield": shield,
		"radiation": radiation,
		"health": health,
		"food": food,
		"water": water,
		"score": mission_score
	}

func get_stats() -> Dictionary:
	var res = get_resources_dict()
	res["events_completed"] = current_event_index
	res["total_events"] = events.size()
	res["radiation_limit"] = MAX_RADIATION_LIMIT
	res["game_mode"] = game_mode
	res["rating"] = calculate_rating()
	return res

func get_current_event_id() -> int:
	if current_event_index < events.size():
		return events[current_event_index].get("id", current_event_index + 1)
	return 0

func calculate_rating() -> String:
	var score_calc: float = 0.0
	score_calc += health * 2.0
	score_calc += energy + oxygen + shield + (food * 1.5) + (water * 1.5) + (mission_score * 3.0)
	score_calc -= radiation * 1.5
	
	if radiation <= 55.0 and health >= 80 and food >= 30 and water >= 25 and energy >= 15:
		return "S - Legendary Mars Commander (NASA & CSA Grand Honor)"
	elif radiation <= 80.0 and health >= 60 and food >= 15:
		return "A - Superior Expedition Leader (Mars Habitation Certified)"
	elif radiation < MAX_RADIATION_LIMIT and health > 0 and food > 0 and water > 0:
		return "B - Mars Survivor (Hardship Survival Commendation)"
	else:
		return "F - Mission Failed"
