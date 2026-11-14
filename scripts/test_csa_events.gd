extends SceneTree

const CsaEventsClass = preload("res://scripts/csa_events.gd")
const GameManagerClass = preload("res://scripts/game_manager.gd")

func _init() -> void:
	print("==================================================")
	print("STARTING AUTOMATED VERIFICATION OF CSA EVENTS...")
	print("==================================================")
	
	var events = CsaEventsClass.get_all_events()
	assert(events.size() == 5, "Must contain exactly 5 CSA events (19, 21, 22, 23, 24)!")
	print("✓ CSA Event count: 5 events verified.")
	
	# Verify Event 19 (Grow Food with 3 choices and delayed food)
	var ev19 = events[0]
	assert(ev19["id"] == 19 and ev19["title"] == "Grow Food (Pick a Crop)")
	assert(ev19.has("choice_c"), "Event 19 must have choice_c!")
	
	var a19 = ev19["choice_a"]["effects"]
	assert(a19["water"] == -3 and a19["energy"] == -3 and a19["delayed_food"] == 10 and a19["delay_turns"] == 1)
	
	var b19 = ev19["choice_b"]["effects"]
	assert(b19["water"] == -5 and b19["energy"] == -4 and b19["delayed_food"] == 18 and b19["delay_turns"] == 2)
	
	var c19 = ev19["choice_c"]["effects"]
	assert(c19["water"] == -8 and c19["energy"] == -6 and c19["delayed_food"] == 26 and c19["delay_turns"] == 3)
	print("✓ Event 19 (Grow Food) verified: 3 choices with exact delayed harvest parameters.")
	print("    - A: %s -> %s" % [ev19["choice_a"]["label"], CsaEventsClass.format_effects(a19)])
	print("    - B: %s -> %s" % [ev19["choice_b"]["label"], CsaEventsClass.format_effects(b19)])
	print("    - C: %s -> %s" % [ev19["choice_c"]["label"], CsaEventsClass.format_effects(c19)])

	# Verify Event 21 (Recycling Water)
	var ev21 = events[1]
	assert(ev21["id"] == 21 and ev21["title"] == "Recycling Water")
	var a21 = ev21["choice_a"]["effects"]
	assert(a21["water"] == 6 and a21["energy"] == -5 and a21["food"] == 7 and a21["oxygen"] == 2)
	var b21 = ev21["choice_b"]["effects"]
	assert(b21["water"] == 3 and b21["energy"] == -2 and b21["food"] == 4)
	print("✓ Event 21 (Recycling Water) verified: A=[%s] B=[%s]" % [CsaEventsClass.format_effects(a21), CsaEventsClass.format_effects(b21)])

	# Verify Event 22 (Mold in the Greenhouse)
	var ev22 = events[2]
	assert(ev22["id"] == 22 and ev22["title"] == "Mold in the Greenhouse")
	var a22 = ev22["choice_a"]["effects"]
	assert(a22["oxygen"] == -3 and a22["energy"] == -3 and a22["food"] == -3)
	var b22 = ev22["choice_b"]["effects"]
	assert(b22["oxygen"] == -1 and b22["food"] == -8)
	print("✓ Event 22 (Mold in the Greenhouse) verified: A=[%s] B=[%s]" % [CsaEventsClass.format_effects(a22), CsaEventsClass.format_effects(b22)])

	# Verify Event 23 (Low on Food)
	var ev23 = events[3]
	assert(ev23["id"] == 23 and ev23["title"] == "Low on Food")
	var a23 = ev23["choice_a"]["effects"]
	assert(a23["energy"] == -1 and a23["food"] == 7 and a23["health"] == -2)
	var b23 = ev23["choice_b"]["effects"]
	assert(b23["energy"] == -2 and b23["food"] == 4 and b23["health"] == -1)
	print("✓ Event 23 (Low on Food) verified: A=[%s] B=[%s]" % [CsaEventsClass.format_effects(a23), CsaEventsClass.format_effects(b23)])

	# Verify Event 24 (Mars Potatoes)
	var ev24 = events[4]
	assert(ev24["id"] == 24 and ev24["title"] == "Mars Potatoes")
	var a24 = ev24["choice_a"]["effects"]
	assert(a24["energy"] == -5 and a24["oxygen"] == -1 and a24["food"] == 12)
	var b24 = ev24["choice_b"]["effects"]
	assert(b24["energy"] == -2 and b24["food"] == 6)
	print("✓ Event 24 (Mars Potatoes) verified: A=[%s] B=[%s]" % [CsaEventsClass.format_effects(a24), CsaEventsClass.format_effects(b24)])

	# --- Test Delayed Harvest Progression in GameManager ---
	print("\n--- Testing Delayed Harvest Progression (Choice A: Lettuce +10 after 1 turn) ---")
	var gm_test = GameManagerClass.new()
	gm_test._ready()
	gm_test.start_game(50, 50, 50, 0.0, 70, 30, 50, "CSA")
	var start_food = gm_test.food
	# Event 19: Pick A (Lettuce) -> immediate water -3, energy -3; harvest after 1 turn
	gm_test.choose_option("A")
	assert(gm_test.pending_harvests.size() == 1, "Pending harvest should be queued")
	# Advance 1 turn (Event 21: Pick B)
	gm_test.choose_option("B")
	# By event 22, the 1-turn lettuce harvest (+10) should have matured!
	print("  Food after 1 turn delay: %d (Started: %d, +4 from Event 21, +10 from Lettuce)" % [gm_test.food, start_food])
	assert(gm_test.food >= start_food + 14, "Lettuce +10 food should have been harvested!")
	print("✓ Delayed crop harvest mechanism verified successfully!")
	gm_test.free()

	# --- Test CSA Mode Simulation (All Choice A) ---
	print("\n--- Simulating CSA Mode (All Choice A) ---")
	var gm_csa_a = GameManagerClass.new()
	gm_csa_a._ready()
	gm_csa_a.start_game(50, 50, 50, 0.0, 70, 30, 50, "CSA")
	for i in range(5):
		gm_csa_a.choose_option("A")
	var stats_ca = gm_csa_a.get_stats()
	print("  Final Stats: Food=%d Water=%d%% Energy=%d%% Oxygen=%d%% Health=%d%%" % [stats_ca.food, stats_ca.water, stats_ca.energy, stats_ca.oxygen, stats_ca.health])
	assert(stats_ca.events_completed == 5, "Should complete all 5 CSA events")
	print("✓ CSA All-A Simulation PASSED! Rating: %s" % gm_csa_a.calculate_rating())
	gm_csa_a.free()

	# --- Test Full 23-Event Expedition Campaign Simulation ---
	print("\n--- Simulating Full 23-Event Expedition Campaign (DONKI + OSDR + RadLab + CSA) ---")
	var gm_exp = GameManagerClass.new()
	gm_exp._ready()
	gm_exp.start_game(80, 70, 70, 0.0, 90, 40, 60, "ALL")
	for i in range(23):
		if i == 18:
			# Event 19 (Grow food): Test Choice C (Dwarf tomatoes)
			gm_exp.choose_option("C")
		elif i % 2 == 0:
			gm_exp.choose_option("A")
		else:
			gm_exp.choose_option("B")
	var stats_exp = gm_exp.get_stats()
	print("  Full Expedition Final Stats: %s" % str(stats_exp))
	assert(stats_exp.events_completed == 23, "Should complete all 23 events")
	print("✓ Full 23-Event Expedition Simulation PASSED! Rating: %s" % gm_exp.calculate_rating())
	gm_exp.free()

	print("\n==================================================")
	print("ALL CSA EVENT VERIFICATIONS PASSED SUCCESSFULLY!")
	print("==================================================")
	quit()

