extends SceneTree

func _init() -> void:
	print("==================================================")
	print("STARTING INTRO MOUSE CLICK DETECTION VERIFICATION...")
	print("==================================================")

	var diag_scene = load("res://scenes/dialogue.tscn")
	assert(diag_scene != null, "Failed to load scenes/dialogue.tscn")
	var diag: IntroDialogue = diag_scene.instantiate()
	root.add_child(diag)

	# Verify mouse_filter settings
	var intro_ctrl: Control = diag.get_node_or_null("IntroControl")
	assert(intro_ctrl != null, "IntroControl missing")
	print("IntroControl mouse_filter: %d (MOUSE_FILTER_PASS=1)" % intro_ctrl.mouse_filter)
	assert(intro_ctrl.mouse_filter == Control.MOUSE_FILTER_PASS, "IntroControl must be MOUSE_FILTER_PASS (1)")

	var anchor_ctrl: Control = diag.get_node_or_null("IntroControl/DialogueAnchor")
	assert(anchor_ctrl != null, "DialogueAnchor missing")
	print("DialogueAnchor mouse_filter: %d (MOUSE_FILTER_PASS=1)" % anchor_ctrl.mouse_filter)
	assert(anchor_ctrl.mouse_filter == Control.MOUSE_FILTER_PASS, "DialogueAnchor must be MOUSE_FILTER_PASS (1)")

	# Verify initial state (Index 0)
	var text_lbl: Label = diag.get_node_or_null("%DialogueText")
	var action_center = diag.get_node_or_null("%ActionButtonsCenter")
	assert(text_lbl != null and action_center != null)

	print("Initial Step Index: %d" % diag.dialogue_index)
	assert(diag.dialogue_index == 0, "Initial dialogue_index must be 0")
	assert(action_center.visible == false, "Action buttons must be hidden initially")
	assert("Warning: Oxygen levels dropping" in text_lbl.text, "Step 0 text mismatch")
	print("✓ Initial Step 0 verified!")

	# Simulate Mouse Click 1 (InputEventMouseButton)
	var mouse_event = InputEventMouseButton.new()
	mouse_event.button_index = MOUSE_BUTTON_LEFT
	mouse_event.pressed = true
	mouse_event.position = Vector2(960, 540) # Center of screen

	print("Simulating left mouse click via _input(event)...")
	diag._input(mouse_event)

	print("After Click 1 - Step Index: %d" % diag.dialogue_index)
	assert(diag.dialogue_index == 1, "dialogue_index must increment to 1 after click")
	assert(action_center.visible == true, "Action buttons must be revealed on step 1")
	assert("Emergency protocols engaged" in text_lbl.text, "Step 1 text mismatch")
	print("✓ Step 0 -> Step 1 mouse click advance verified! Centered action buttons revealed.")

	# Simulate Click on START MISSION button
	var signal_received = [false]
	diag.intro_finished.connect(func(): signal_received[0] = true)

	print("Simulating click on START MISSION to trigger mission...")
	diag._on_start_mission_pressed()
	assert(signal_received[0] == true, "intro_finished must be emitted on START MISSION click")
	print("✓ START MISSION click correctly emitted intro_finished signal!")

	diag.queue_free()
	print("==================================================")
	print("ALL MOUSE CLICK DETECTION TESTS PASSED!")
	print("==================================================")
	quit()
