extends SceneTree

func _init() -> void:
	print("==================================================")
	print("STARTING BADGES & MISSION ACHIEVEMENTS VERIFICATION...")
	print("==================================================")

	# 1. Verify Badges Data
	var badges = BadgesData.get_all_badges()
	assert(badges.size() == 6, "Must contain exactly 6 mission achievements! Got %d" % badges.size())
	print("✓ Exactly 6 mission badges verified in BadgesData.")

	var expected_ids = [
		"badge_solar_shield",
		"badge_flight_surgeon",
		"badge_dosimetry_master",
		"badge_martian_botanist",
		"badge_stem_scholar",
		"badge_mars_commander"
	]

	for i in range(6):
		var b = badges[i]
		assert(b["id"] == expected_ids[i], "Badge %d id mismatch: expected %s, got %s" % [i, expected_ids[i], b["id"]])
		assert(b.has("title") and b["title"].length() > 0, "Badge missing title")
		assert(b.has("icon") and b["icon"].length() > 0, "Badge missing icon")
		assert(b.has("category") and b["category"].length() > 0, "Badge missing category")
		assert(b.has("desc") and b["desc"].length() > 0, "Badge missing desc")
		assert(b.has("requirement") and b["requirement"].length() > 0, "Badge missing requirement")
		print("  ✓ [%s] %s %s: '%s'" % [b["id"], b["icon"], b["category"], b["title"]])

	# 2. Verify Unlock Logic
	var initial_stats = {"events_completed": 0, "health": 80, "radiation": 0.0, "score": 0}
	assert(BadgesData.is_badge_unlocked("badge_solar_shield", initial_stats, []) == false, "Should be locked at start")

	var donki_stats = {"events_completed": 8, "health": 75, "radiation": 15.0, "score": 0}
	assert(BadgesData.is_badge_unlocked("badge_solar_shield", donki_stats, []) == true, "DONKI shield badge should unlock after event 8")

	var osdr_stats = {"events_completed": 14, "health": 80, "radiation": 25.0, "score": 0}
	assert(BadgesData.is_badge_unlocked("badge_flight_surgeon", osdr_stats, []) == true, "Flight surgeon badge should unlock with health >= 70")

	var osdr_low_health = {"events_completed": 14, "health": 50, "radiation": 25.0, "score": 0}
	assert(BadgesData.is_badge_unlocked("badge_flight_surgeon", osdr_low_health, []) == false, "Flight surgeon badge should not unlock with health < 70")

	var radlab_stats = {"events_completed": 18, "health": 70, "radiation": 35.0, "score": 0}
	assert(BadgesData.is_badge_unlocked("badge_dosimetry_master", radlab_stats, []) == true, "Dosimetry badge should unlock with rad < 40 mSv")

	var radlab_high_rad = {"events_completed": 18, "health": 70, "radiation": 65.0, "score": 0}
	assert(BadgesData.is_badge_unlocked("badge_dosimetry_master", radlab_high_rad, []) == false, "Dosimetry badge should not unlock with rad >= 40 mSv")

	var csa_stats = {"events_completed": 24, "health": 70, "radiation": 35.0, "score": 0}
	assert(BadgesData.is_badge_unlocked("badge_martian_botanist", csa_stats, []) == true, "Martian botanist should unlock at event 24")

	var stem_stats = {"events_completed": 28, "health": 70, "radiation": 35.0, "score": 3}
	assert(BadgesData.is_badge_unlocked("badge_stem_scholar", stem_stats, []) == true, "STEM scholar should unlock with score >= 3")

	var victory_stats = {"events_completed": 30, "health": 85, "radiation": 50.0, "score": 9, "rating": "S - Legendary Mars Commander"}
	assert(BadgesData.is_badge_unlocked("badge_mars_commander", victory_stats, []) == true, "Mars commander should unlock on S-rank victory")
	print("✓ All 6 badge unlock conditions verified!")

	# 3. Verify UI Scene & Instantiation
	var badges_scene = load("res://scenes/badges.tscn")
	assert(badges_scene != null, "Failed to load scenes/badges.tscn")
	var modal: BadgesModal = badges_scene.instantiate()
	root.add_child(modal)
	modal._ensure_nodes()

	assert(modal.backdrop != null, "Backdrop missing")
	assert(modal.modal_panel != null, "ModalPanel missing")
	assert(modal.btn_close != null, "BtnClose missing")
	assert(modal.badges_counter != null, "BadgesCounter missing")
	assert(modal.badges_container != null, "BadgesContainer missing")
	assert(modal.badges_container.get_child_count() == 6, "Must have 6 badge cards in container, got %d" % modal.badges_container.get_child_count())
	print("✓ BadgesModal scene hierarchy and 6 cards verified.")

	# 4. Verify Refresh with Stats
	modal.refresh_badges(victory_stats, [])
	assert(modal.unlocked_count == 6, "All 6 badges should unlock with perfect victory stats, got %d" % modal.unlocked_count)
	assert(modal.badges_counter.text == "ACHIEVED: 6 OF 6", "Counter mismatch: %s" % modal.badges_counter.text)
	print("✓ Badges refresh with stats verified (6/6 achieved).")

	# 5. Verify Open / Close
	modal.open(initial_stats, [])
	assert(modal.visible == true, "Modal must be visible when open")
	modal.close()
	print("✓ Open and Close verified.")

	modal.queue_free()

	# 6. Verify Dialogue Integration
	var diag_scene = load("res://scenes/dialogue.tscn")
	assert(diag_scene != null, "Failed to load scenes/dialogue.tscn")
	var diag: IntroDialogue = diag_scene.instantiate()
	root.add_child(diag)
	diag._ensure_nodes()

	var btn_b: Button = diag.get_node_or_null("%BtnBadges")
	assert(btn_b != null, "BtnBadges must be present in dialogue scene")

	diag._on_badges_pressed()
	assert(diag.badges_instance != null, "badges_instance must be created upon pressing BtnBadges")
	assert(diag.badges_instance.visible == true, "badges_instance must be visible after opening")
	print("✓ Integration with IntroDialogue verified: clicking BtnBadges opens BadgesModal!")

	diag.queue_free()

	print("==================================================")
	print("ALL BADGES & ACHIEVEMENTS TESTS PASSED SUCCESSFULLY!")
	print("==================================================")
	quit(0)
