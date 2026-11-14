extends SceneTree

func _init() -> void:
	print("==================================================")
	print("TESTING INTRO TEASER & CLEAN EVENT UI...")
	print("==================================================")

	# 1. Test Intro Teaser Dialogue Scene
	var diag_scene = load("res://scenes/dialogue.tscn")
	assert(diag_scene != null, "Failed to load scenes/dialogue.tscn")
	var diag = diag_scene.instantiate()
	root.add_child(diag)

	var text_lbl: Label = diag.get_node_or_null("%DialogueText")
	var click_lbl: Label = diag.get_node_or_null("%ClickHint")
	var btn_start: Button = diag.get_node_or_null("%BtnStartMission")
	var btn_how: Button = diag.get_node_or_null("%BtnHowToPlay")
	var action_center = diag.get_node_or_null("%ActionButtonsCenter")
	var warning_icon: TextureRect = diag.get_node_or_null("%WarningIcon")

	assert(text_lbl != null, "DialogueText node not found")
	assert(click_lbl != null, "ClickHint node not found")
	assert(btn_start != null, "BtnStartMission node not found")
	assert(btn_how != null, "BtnHowToPlay node not found")
	assert(warning_icon != null, "WarningIcon node not found")

	# Verify Step 0
	print("Step 0 Text: %s" % text_lbl.text)
	assert("Warning: Oxygen levels dropping" in text_lbl.text, "Step 0 text mismatch")
	assert(action_center.visible == false, "Action buttons must be hidden on Step 0")
	print("✓ Step 0 verified inside glowing frame with warning icon!")

	# Advance to Step 1
	diag.handle_advance()
	print("Step 1 Text: %s" % text_lbl.text)
	assert("Emergency protocols engaged" in text_lbl.text, "Step 1 text mismatch")
	assert(action_center.visible == true, "Action buttons must be revealed on Step 1")
	print("✓ Step 1 verified with centered START & HOW TO PLAY buttons revealed!")

	# Verify signal emission on START
	var signal_box = [false]
	diag.intro_finished.connect(func(): signal_box[0] = true)
	diag._on_start_mission_pressed()
	assert(signal_box[0] == true, "intro_finished signal was not emitted")
	print("✓ START MISSION button click cleanly emits intro_finished signal!")

	diag.queue_free()

	# 2. Test DonkiEventSystem UI without Category Filter Bar
	var donki_scene = load("res://scenes/donki_event_system.tscn")
	assert(donki_scene != null, "Failed to load scenes/donki_event_system.tscn")
	var donki = donki_scene.instantiate()
	root.add_child(donki)

	var mode_box = donki.get_node_or_null("%ModeSelectorBox")
	assert(mode_box == null, "ModeSelectorBox should be completely removed")
	assert(donki.get_node_or_null("%BtnModeAll") == null, "BtnModeAll must be removed")
	assert(donki.get_node_or_null("%BtnModeDonki") == null, "BtnModeDonki must be removed")

	var event_counter: Label = donki.get_node_or_null("%EventCounter")
	var donki_badge: Label = donki.get_node_or_null("%DonkiBadge")
	var event_title: Label = donki.get_node_or_null("%EventTitle")

	assert(event_counter != null, "EventCounter must be present")
	assert(donki_badge != null, "DonkiBadge must be present")
	assert(event_title != null, "EventTitle must be present")

	print("✓ Category filter bar completely removed from Event Card UI!")
	print("Current Event Title: %s" % event_title.text)
	print("Current Badge: %s" % donki_badge.text)
	print("Current Counter: %s" % event_counter.text)

	donki.queue_free()

	print("==================================================")
	print("ALL INTRO TEASER & EVENT UI TESTS PASSED!")
	print("==================================================")
	quit()
