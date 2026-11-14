extends SceneTree

const MarsStemEventsClass = preload("res://scripts/mars_stem_events.gd")
const GameManagerClass = preload("res://scripts/game_manager.gd")

func _init() -> void:
	print("==================================================")
	print("STARTING VERIFICATION OF MARS & STEM EVENTS (20, 25-30)...")
	print("==================================================")
	
	var events = MarsStemEventsClass.get_all_events()
	assert(events.size() == 7, "Must contain exactly 7 events (20, 25, 26, 27, 28, 29, 30)!")
	print("✓ Mars & STEM Event count: 7 events verified.")
	
	# Verify Event 20: 4 choices with base passive modifiers
	var ev20 = events[0]
	assert(ev20["id"] == 20 and ev20["title"] == "Time to Move (Mars Map Selection)")
	assert(ev20.has("choice_a") and ev20.has("choice_b") and ev20.has("choice_c") and ev20.has("choice_d"))
	
	var a20 = ev20["choice_a"]["effects"]
	assert(a20["energy"] == -10 and a20["oxygen"] == -4 and a20["score_per_turn"] == 3)
	var b20 = ev20["choice_b"]["effects"]
	assert(b20["energy"] == -8 and b20["oxygen"] == -4 and b20["water_per_turn"] == 3)
	var c20 = ev20["choice_c"]["effects"]
	assert(c20["energy"] == -12 and c20["oxygen"] == -5 and c20["water_per_turn"] == 4 and c20["energy_per_turn"] == -2)
	var d20 = ev20["choice_d"]["effects"]
	assert(d20["energy"] == -12 and d20["oxygen"] == -5 and is_equal_approx(d20["radiation_multiplier"], 0.85) and is_equal_approx(d20["dust_multiplier"], 1.5))
	print("✓ Event 20 (Mars Map Selection): 4 choices verified with passive base modifiers.")
	print("    - A: %s -> %s" % [ev20["choice_a"]["label"], MarsStemEventsClass.format_effects(a20)])
	print("    - B: %s -> %s" % [ev20["choice_b"]["label"], MarsStemEventsClass.format_effects(b20)])
	print("    - C: %s -> %s" % [ev20["choice_c"]["label"], MarsStemEventsClass.format_effects(c20)])
	print("    - D: %s -> %s" % [ev20["choice_d"]["label"], MarsStemEventsClass.format_effects(d20)])

	# Verify Event 25 (Quiz: Does Water Protect?)
	var ev25 = events[1]
	assert(ev25["id"] == 25 and ev25["title"] == "Quiz: Does Water Protect?")
	var a25 = ev25["choice_a"]["effects"]
	assert(a25["health"] == 3)
	var b25 = ev25["choice_b"]["effects"]
	assert(b25["shield"] == -3 and is_equal_approx(b25["radiation"], 5.0))
	print("✓ Event 25 (Quiz: Does Water Protect?): A=[%s] B=[%s]" % [MarsStemEventsClass.format_effects(a25), MarsStemEventsClass.format_effects(b25)])

	# Verify Event 26 (Quiz: Why Exercise?)
	var ev26 = events[2]
	assert(ev26["id"] == 26 and ev26["title"] == "Quiz: Why Exercise?")
	var a26 = ev26["choice_a"]["effects"]
	assert(a26["energy"] == -2 and a26["health"] == -2)
	var b26 = ev26["choice_b"]["effects"]
	assert(b26["energy"] == -1 and b26["health"] == 6)
	print("✓ Event 26 (Quiz: Why Exercise?): A=[%s] B=[%s]" % [MarsStemEventsClass.format_effects(a26), MarsStemEventsClass.format_effects(b26)])

	# Verify Event 27 (Quiz: The Sun)
	var ev27 = events[3]
	assert(ev27["id"] == 27 and ev27["title"] == "Quiz: The Sun")
	var a27 = ev27["choice_a"]["effects"]
	assert(a27["energy"] == 3 and a27["health"] == 2)
	var b27 = ev27["choice_b"]["effects"]
	assert(b27["energy"] == -3 and b27["shield"] == -3)
	print("✓ Event 27 (Quiz: The Sun): A=[%s] B=[%s]" % [MarsStemEventsClass.format_effects(a27), MarsStemEventsClass.format_effects(b27)])

	# Verify Event 28 (Dust Storm on Mars)
	var ev28 = events[4]
	assert(ev28["id"] == 28 and ev28["title"] == "Dust Storm on Mars")
	var a28 = ev28["choice_a"]["effects"]
	assert(a28["energy"] == -6 and a28["oxygen"] == -2)
	var b28 = ev28["choice_b"]["effects"]
	assert(b28["oxygen"] == -5 and b28["energy"] == -3 and b28["shield"] == -2)
	print("✓ Event 28 (Dust Storm on Mars): A=[%s] B=[%s]" % [MarsStemEventsClass.format_effects(a28), MarsStemEventsClass.format_effects(b28)])

	# Verify Event 29 (The Cold Mars Night)
	var ev29 = events[5]
	assert(ev29["id"] == 29 and ev29["title"] == "The Cold Mars Night")
	var a29 = ev29["choice_a"]["effects"]
	assert(a29["energy"] == -12 and a29["shield"] == -1)
	var b29 = ev29["choice_b"]["effects"]
	assert(b29["oxygen"] == -5 and b29["energy"] == -6)
	print("✓ Event 29 (The Cold Mars Night): A=[%s] B=[%s]" % [MarsStemEventsClass.format_effects(a29), MarsStemEventsClass.format_effects(b29)])

	# Verify Event 30 (Oxygen Leak)
	var ev30 = events[6]
	assert(ev30["id"] == 30 and ev30["title"] == "Oxygen Leak")
	var a30 = ev30["choice_a"]["effects"]
	assert(a30["energy"] == -3 and a30["oxygen"] == -5)
	var b30 = ev30["choice_b"]["effects"]
	assert(b30["oxygen"] == -8 and b30["energy"] == -1 and b30["shield"] == -2)
	print("✓ Event 30 (Oxygen Leak): A=[%s] B=[%s]" % [MarsStemEventsClass.format_effects(a30), MarsStemEventsClass.format_effects(b30)])

	# --- Test Event 20 Passive Modifier Execution in GameManager ---
	print("\n--- Testing Event 20 Base Selection (Choice B: Arcadia Planitia +3 Water/turn) ---")
	var gm_base = GameManagerClass.new()
	gm_base._ready()
	gm_base.start_game(60, 60, 60, 0.0, 80, 40, 50, "MARS")
	var water_init = gm_base.water
	# Event 20: Pick Choice B (Arcadia) -> immediate water +3/turn modifier
	gm_base.choose_option("B")
	assert(gm_base.base_water_per_turn == 3, "Arcadia Planitia should establish +3 water/turn")
	# Advance turn (Event 25)
	gm_base.choose_option("A")
	print("  Water after 1 subsequent turn at Arcadia Base: %d (Started: %d, +3/turn active)" % [gm_base.water, water_init])
	assert(gm_base.water >= water_init + 3, "Arcadia +3 water per turn should be applied!")
	print("✓ Base passive modifier successfully applied across turns!")
	gm_base.free()

	# --- Test MARS Mode Simulation ---
	print("\n--- Simulating MARS Mode (Balanced Strategic Choices) ---")
	var gm_mars = GameManagerClass.new()
	gm_mars._ready()
	gm_mars.start_game(70, 70, 70, 0.0, 80, 40, 50, "MARS")
	# Event 20: B (Arcadia), 25: A (True), 26: B (Muscles), 27: A (True), 28: A (Save), 29: B (Generator), 30: A (Plug)
	var choices = ["B", "A", "B", "A", "A", "B", "A"]
	for c in choices:
		gm_mars.choose_option(c)
	var stats_m = gm_mars.get_stats()
	print("  Final Stats: Energy=%d%% Oxygen=%d%% Health=%d%% Shield=%d%% Water=%d%%" % [stats_m.energy, stats_m.oxygen, stats_m.health, stats_m.shield, stats_m.water])
	assert(stats_m.events_completed == 7, "Should complete all 7 MARS events")
	print("✓ MARS Mode Simulation PASSED! Rating: %s" % gm_mars.calculate_rating())
	gm_mars.free()

	# --- Test Full 30-Event Complete Storyline Campaign ---
	print("\n--- Simulating Full 30-Event Grand Campaign (Events 1 to 30) ---")
	var gm_grand = GameManagerClass.new()
	gm_grand._ready()
	# Balanced commander stats for 30-event long-duration mission
	gm_grand.start_game(95, 85, 80, 0.0, 90, 50, 70, "ALL")
	assert(gm_grand.events.size() == 30, "Grand campaign must contain all 30 events in sequence!")
	
	for i in range(30):
		var ev_curr = gm_grand.events[i]
		if ev_curr["id"] == 19:
			gm_grand.choose_option("B") # Potatoes (+18 food after 2 turns)
		elif ev_curr["id"] == 20:
			gm_grand.choose_option("B") # Arcadia (+3 water/turn)
		elif ev_curr["id"] in [25, 27]:
			gm_grand.choose_option("A") # True
		elif ev_curr["id"] == 26:
			gm_grand.choose_option("B") # Strong muscles
		elif ev_curr["id"] == 28:
			gm_grand.choose_option("B") # Clean panels
		elif ev_curr["id"] == 29:
			gm_grand.choose_option("B") # Generator
		elif i % 2 == 0:
			gm_grand.choose_option("A")
		else:
			gm_grand.choose_option("B")
			
	var stats_grand = gm_grand.get_stats()
	print("  Grand Campaign Final Telemetry: %s" % str(stats_grand))
	assert(stats_grand.events_completed == 30, "Should complete all 30 events in grand campaign")
	print("✓ Grand 30-Event Campaign Simulation PASSED! Rating: %s" % gm_grand.calculate_rating())
	gm_grand.free()

	print("\n==================================================")
	print("ALL MARS, STEM & GRAND CAMPAIGN VERIFICATIONS PASSED!")
	print("==================================================")
	quit()

