extends SceneTree

const RadLabEventsClass = preload("res://scripts/radlab_events.gd")
const GameManagerClass = preload("res://scripts/game_manager.gd")

func _init() -> void:
	print("==================================================")
	print("STARTING AUTOMATED VERIFICATION OF RADLAB EVENTS..")
	print("==================================================")
	
	var events = RadLabEventsClass.get_all_events()
	assert(events.size() == 4, "Must contain exactly 4 RadLab events (Events 15 to 18)!")
	print("✓ RadLab Event count: 4 events verified.")
	
	# Expected definitions for Events 15 to 18
	var expected = [
		{
			"id": 15,
			"title": "Quiet Day",
			"a": {"energy": -1, "radiation": 10.5},
			"b": {"energy": -3, "shield": -1, "radiation": 9.0}
		},
		{
			"id": 16,
			"title": "More Radiation Zone",
			"a": {"oxygen": -2, "radiation": 5.0},
			"b": {"energy": -4, "shield": -3, "radiation": 3.0}
		},
		{
			"id": 17,
			"title": "A Thicker Wall",
			"a": {"water": -4, "energy": -2, "food": -2},
			"b": {"energy": -6, "shield": -2}
		},
		{
			"id": 18,
			"title": "Dosimeter Alarm",
			"a": {"oxygen": -3, "energy": -1, "radiation": 4.0},
			"b": {"energy": -5, "shield": -5, "radiation": 2.0}
		}
	]
	
	for i in range(4):
		var ev = events[i]
		var exp = expected[i]
		assert(ev["id"] == exp["id"], "Event ID mismatch on event %d" % (i+15))
		assert(ev["title"] == exp["title"], "Event title mismatch on event %d" % (i+15))
		
		# Check Choice A
		var act_a = ev["choice_a"]["effects"]
		for k in exp["a"]:
			assert(act_a.has(k), "Missing key %s in event %d Choice A" % [k, i+15])
			assert(is_equal_approx(float(act_a[k]), float(exp["a"][k])), "Choice A effect mismatch on event %d key %s (expected %s, got %s)" % [i+15, k, str(exp["a"][k]), str(act_a[k])])
			
		# Check Choice B
		var act_b = ev["choice_b"]["effects"]
		for k in exp["b"]:
			assert(act_b.has(k), "Missing key %s in event %d Choice B" % [k, i+15])
			assert(is_equal_approx(float(act_b[k]), float(exp["b"][k])), "Choice B effect mismatch on event %d key %s (expected %s, got %s)" % [i+15, k, str(exp["b"][k]), str(act_b[k])])
			
		print("✓ Event %d (%s) verified:" % [ev["id"], ev["title"]])
		print("    - Choice A: %s -> %s" % [ev["choice_a"]["label"], RadLabEventsClass.format_effects(act_a)])
		print("    - Choice B: %s -> %s" % [ev["choice_b"]["label"], RadLabEventsClass.format_effects(act_b)])

	# --- Test RadLab-Only Simulation (All Choice A) ---
	print("\n--- Simulating RadLab Mode (All Choice A) ---")
	var gm_rad_a = GameManagerClass.new()
	gm_rad_a._ready()
	gm_rad_a.start_game(50, 50, 50, 0.0, 70, 30, 50, "RADLAB")
	for i in range(4):
		gm_rad_a.choose_option("A")
	var stats_ra = gm_rad_a.get_stats()
	print("  Final Stats: Energy=%d%% Oxygen=%d%% Water=%d%% Radiation=%.1f mSv Food=%d" % [stats_ra.energy, stats_ra.oxygen, stats_ra.water, stats_ra.radiation, stats_ra.food])
	assert(stats_ra.events_completed == 4, "Should complete all 4 RadLab events")
	print("✓ RadLab All-A Simulation PASSED! Rating: %s" % gm_rad_a.calculate_rating())
	gm_rad_a.free()

	# --- Test RadLab-Only Simulation (All Choice B) ---
	print("\n--- Simulating RadLab Mode (All Choice B) ---")
	var gm_rad_b = GameManagerClass.new()
	gm_rad_b._ready()
	gm_rad_b.start_game(50, 50, 50, 0.0, 70, 30, 50, "RADLAB")
	for i in range(4):
		gm_rad_b.choose_option("B")
	var stats_rb = gm_rad_b.get_stats()
	print("  Final Stats: Energy=%d%% Shield=%d%% Radiation=%.1f mSv Water=%d%%" % [stats_rb.energy, stats_rb.shield, stats_rb.radiation, stats_rb.water])
	assert(stats_rb.events_completed == 4, "Should complete all 4 RadLab events")
	print("✓ RadLab All-B Simulation PASSED! Rating: %s" % gm_rad_b.calculate_rating())
	gm_rad_b.free()

	# --- Test Full 18-Event Campaign Simulation (Events 1 to 18) ---
	print("\n--- Simulating Full 18-Event Campaign: DONKI (1-8) + OSDR (9-14) + RadLab (15-18) ---")
	var gm_full = GameManagerClass.new()
	gm_full._ready()
	gm_full.start_game(60, 60, 60, 0.0, 80, 40, 50, "ALL")
	for i in range(18):
		# Alternate choices
		if i % 2 == 0:
			gm_full.choose_option("A")
		else:
			gm_full.choose_option("B")
	var stats_full = gm_full.get_stats()
	print("  Full 18-Event Campaign Final Stats: %s" % str(stats_full))
	assert(stats_full.events_completed == 18, "Should complete all 18 events in full campaign")
	print("✓ Full 18-Event Campaign Simulation PASSED! Rating: %s" % gm_full.calculate_rating())
	gm_full.free()

	print("\n==================================================")
	print("ALL RADLAB EVENT VERIFICATIONS PASSED SUCCESSFULLY!")
	print("==================================================")
	quit()

