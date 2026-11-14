extends SceneTree

func _init() -> void:
	print("==================================================")
	print("STARTING AUTOMATED VERIFICATION OF OSDR EVENTS...")
	print("==================================================")
	
	var events = OsdrEvents.get_all_events()
	assert(events.size() == 6, "Must contain exactly 6 OSDR events (Events 9 to 14)!")
	print("✓ OSDR Event count: 6 events verified.")
	
	# Expected definitions for Events 9 to 14
	var expected = [
		{
			"id": 9,
			"title": "Sleeping Badly",
			"a": {"energy": -3, "health": 5},
			"b": {"oxygen": -2, "health": 4}
		},
		{
			"id": 10,
			"title": "Tired Muscles",
			"a": {"oxygen": -4, "energy": -2, "health": 8},
			"b": {"energy": -5, "health": 8}
		},
		{
			"id": 11,
			"title": "Fragile Bones",
			"a": {"oxygen": -3, "health": 6},
			"b": {"energy": -5, "health": 6}
		},
		{
			"id": 12,
			"title": "An Astronaut Has a Cold",
			"a": {"oxygen": -4, "health": 8},
			"b": {"energy": -2, "food": -1, "health": 5}
		},
		{
			"id": 13,
			"title": "Feeling Blue",
			"a": {"oxygen": -2, "energy": -2, "health": 6},
			"b": {"energy": -4, "health": 6}
		},
		{
			"id": 14,
			"title": "Exercise Time",
			"a": {"oxygen": -4, "energy": -3, "health": 8},
			"b": {"oxygen": -1, "energy": -1, "health": 4}
		}
	]
	
	for i in range(6):
		var ev = events[i]
		var exp = expected[i]
		assert(ev["id"] == exp["id"], "Event ID mismatch on event %d" % (i+9))
		assert(ev["title"] == exp["title"], "Event title mismatch on event %d" % (i+9))
		
		# Check Choice A
		var act_a = ev["choice_a"]["effects"]
		for k in exp["a"]:
			assert(act_a.get(k) == exp["a"][k], "Choice A effect mismatch on event %d key %s (expected %d, got %s)" % [i+9, k, exp["a"][k], str(act_a.get(k))])
			
		# Check Choice B
		var act_b = ev["choice_b"]["effects"]
		for k in exp["b"]:
			assert(act_b.get(k) == exp["b"][k], "Choice B effect mismatch on event %d key %s (expected %d, got %s)" % [i+9, k, exp["b"][k], str(act_b.get(k))])
			
		print("✓ Event %d (%s) verified:" % [ev["id"], ev["title"]])
		print("    - Choice A: %s -> %s" % [ev["choice_a"]["label"], OsdrEvents.format_effects(act_a)])
		print("    - Choice B: %s -> %s" % [ev["choice_b"]["label"], OsdrEvents.format_effects(act_b)])

	# --- Test OSDR-Only Simulation (All Choice A) ---
	print("\n--- Simulating OSDR Mode (All Choice A) ---")
	var gm_osdr_a = GameManager.new()
	gm_osdr_a._ready()
	gm_osdr_a.start_game(50, 50, 50, 0, 70, 30, 50, "OSDR")
	for i in range(6):
		gm_osdr_a.choose_option("A")
	var stats_oa = gm_osdr_a.get_stats()
	print("  Final Stats: Health=%d%% Energy=%d%% Oxygen=%d%% Food=%d" % [stats_oa.health, stats_oa.energy, stats_oa.oxygen, stats_oa.food])
	assert(stats_oa.events_completed == 6, "Should complete all 6 OSDR events")
	print("✓ OSDR All-A Simulation PASSED! Rating: %s" % gm_osdr_a.calculate_rating())
	gm_osdr_a.free()

	# --- Test OSDR-Only Simulation (All Choice B) ---
	print("\n--- Simulating OSDR Mode (All Choice B) ---")
	var gm_osdr_b = GameManager.new()
	gm_osdr_b._ready()
	gm_osdr_b.start_game(50, 50, 50, 0, 70, 30, 50, "OSDR")
	for i in range(6):
		gm_osdr_b.choose_option("B")
	var stats_ob = gm_osdr_b.get_stats()
	print("  Final Stats: Health=%d%% Energy=%d%% Oxygen=%d%% Food=%d" % [stats_ob.health, stats_ob.energy, stats_ob.oxygen, stats_ob.food])
	assert(stats_ob.events_completed == 6, "Should complete all 6 OSDR events")
	print("✓ OSDR All-B Simulation PASSED! Rating: %s" % gm_osdr_b.calculate_rating())
	gm_osdr_b.free()

	# --- Test Full Combined Campaign (Events 1 to 14) ---
	print("\n--- Simulating Full Campaign: DONKI (1-8) + OSDR (9-14) ---")
	var gm_full = GameManager.new()
	gm_full._ready()
	gm_full.start_game(50, 50, 50, 0, 70, 30, 50, "ALL")
	for i in range(14):
		# Balance choices across campaign
		if i % 2 == 0:
			gm_full.choose_option("A")
		else:
			gm_full.choose_option("B")
	var stats_full = gm_full.get_stats()
	print("  Full Campaign Final Stats: %s" % str(stats_full))
	assert(stats_full.events_completed == 14, "Should complete all 14 events in full campaign")
	print("✓ Full 14-Event Campaign Simulation PASSED! Rating: %s" % gm_full.calculate_rating())
	gm_full.free()

	print("\n==================================================")
	print("ALL OSDR EVENT VERIFICATIONS PASSED SUCCESSFULLY!")
	print("==================================================")
	quit()

