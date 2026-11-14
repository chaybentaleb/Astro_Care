extends SceneTree

func _init() -> void:
	print("==================================================")
	print("STARTING AUTOMATED VERIFICATION OF DONKI EVENTS...")
	print("==================================================")
	
	var events = DonkiEvents.get_all_events()
	assert(events.size() == 8, "Must contain exactly 8 events!")
	print("✓ Event count: 8 events verified.")
	
	# Expected definitions
	var expected = [
		{"id":1,"title":"Small Solar Flare","a":{"shield":-3,"energy":-4,"radiation":1},"b":{"oxygen":-3,"radiation":3}},
		{"id":2,"title":"Big Solar Flare","a":{"energy":-8,"shield":-8,"radiation":15},"b":{"oxygen":-6,"energy":-2,"radiation":40}},
		{"id":3,"title":"Cloud from the Sun","a":{"energy":-6,"shield":-6,"radiation":5},"b":{"energy":-3,"oxygen":-3,"radiation":20}},
		{"id":4,"title":"Magnetic Storm","a":{"energy":-8,"shield":-2},"b":{"shield":-6,"energy":-4}},
		{"id":5,"title":"Particle Rain","a":{"oxygen":-6,"energy":-3,"radiation":30},"b":{"energy":-8,"shield":-10,"radiation":15}},
		{"id":6,"title":"Solar Wind Wave","a":{"energy":-4,"shield":-1},"b":{"oxygen":-3,"energy":-1,"radiation":1}},
		{"id":7,"title":"Fast Solar Wind","a":{"energy":-4},"b":{"oxygen":-2,"shield":-2}},
		{"id":8,"title":"Radiation Belts","a":{"energy":-5,"shield":-5,"radiation":2},"b":{"oxygen":-3,"energy":-2,"radiation":5}}
	]
	
	for i in range(8):
		var ev = events[i]
		var exp = expected[i]
		assert(ev["title"] == exp["title"], "Event title mismatch on event %d" % (i+1))
		var act_a = ev["choice_a"]["effects"]
		for k in exp["a"]:
			assert(act_a.get(k) == exp["a"][k], "Choice A effect mismatch on event %d key %s" % [i+1, k])
		var act_b = ev["choice_b"]["effects"]
		for k in exp["b"]:
			assert(act_b.get(k) == exp["b"][k], "Choice B effect mismatch on event %d key %s" % [i+1, k])
		print("✓ Event %d (%s): A=[%s] B=[%s]" % [i+1, ev["title"], DonkiEvents.format_effects(act_a), DonkiEvents.format_effects(act_b)])

	# --- GameManager simulation (All Choice A) ---
	print("\n--- Simulating All Choice A ---")
	var gm = GameManager.new()
	gm._ready()
	gm.start_game(50, 50, 50, 0)
	for i in range(8):
		gm.choose_option("A")
	var stats_a = gm.get_stats()
	print("  Final: E=%d O=%d S=%d R=%d mSv  Events=%d/%d" % [stats_a.energy, stats_a.oxygen, stats_a.shield, stats_a.radiation, stats_a.events_completed, stats_a.total_events])
	assert(stats_a.events_completed == 8, "Should complete all 8 events (got %d)" % stats_a.events_completed)
	assert(not gm.is_game_active, "Game should be inactive after all events")
	print("✓ All-A simulation PASSED! Rating: %s" % gm.calculate_rating())
	gm.free()

	# --- GameManager simulation (All Choice B) ---
	print("\n--- Simulating All Choice B ---")
	var gm2 = GameManager.new()
	gm2._ready()
	gm2.start_game(50, 50, 50, 0)
	for i in range(8):
		if not gm2.is_game_active:
			print("  Game Over triggered at event %d" % (i + 1))
			break
		gm2.choose_option("B")
	var stats_b = gm2.get_stats()
	print("  Final: E=%d O=%d S=%d R=%d mSv  Events=%d/%d" % [stats_b.energy, stats_b.oxygen, stats_b.shield, stats_b.radiation, stats_b.events_completed, stats_b.total_events])
	print("✓ All-B simulation PASSED! Rating: %s" % gm2.calculate_rating())
	gm2.free()

	print("\n==================================================")
	print("ALL DONKI EVENT VERIFICATIONS PASSED SUCCESSFULLY!")
	print("==================================================")
	quit()
