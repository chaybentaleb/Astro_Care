extends SceneTree

func _init() -> void:
	print("==================================================")
	print("STARTING 'HOW TO PLAY' MODAL & BUTTON LAYOUT TESTS...")
	print("==================================================")

	var diag_scene = load("res://scenes/dialogue.tscn")
	assert(diag_scene != null, "Failed to load scenes/dialogue.tscn")
	var diag: IntroDialogue = diag_scene.instantiate()
	root.add_child(diag)

	# 1. Initial State Checks (Step 0)
	var action_center = diag.get_node_or_null("%ActionButtonsCenter")
	var btn_start_mission: Button = diag.get_node_or_null("%BtnStartMission")
	var btn_how_to_play: Button = diag.get_node_or_null("%BtnHowToPlay")
	var modal: PanelContainer = diag.get_node_or_null("%HowToPlayModal")

	assert(action_center != null, "ActionButtonsCenter missing")
	assert(btn_start_mission != null, "BtnStartMission missing")
	assert(btn_how_to_play != null, "BtnHowToPlay missing")
	assert(modal != null, "HowToPlayModal missing")

	assert(action_center.visible == false, "Action buttons must be hidden on Step 0")
	assert(modal.visible == false, "Modal must be hidden on Step 0")
	print("✓ Step 0 verified: buttons and modal correctly hidden initially.")

	# 2. Advance to Step 1
	var mouse_event = InputEventMouseButton.new()
	mouse_event.button_index = MOUSE_BUTTON_LEFT
	mouse_event.pressed = true
	diag._input(mouse_event)

	assert(diag.dialogue_index == 1, "Must advance to dialogue index 1")
	assert(action_center.visible == true, "Action buttons must be revealed on Step 1")
	print("✓ Step 1 verified: ActionButtonsCenter revealed in center of screen!")
	print("  Button 1: '%s'" % btn_start_mission.text)
	print("  Button 2: '%s'" % btn_how_to_play.text)
	assert("START MISSION" in btn_start_mission.text)
	assert("HOW TO PLAY" in btn_how_to_play.text)

	# 3. Test Opening 'How to Play' Modal
	diag._on_how_to_play_pressed()
	assert(modal.visible == true, "HowToPlayModal must be visible after clicking How to Play")
	print("✓ 'HOW TO PLAY' modal opened successfully!")

	# Verify 5 Rules in Modal
	var rule1_desc = modal.get_node_or_null("Margin/VBox/RulesList/Rule1/Margin/HBox/Desc")
	var rule2_desc = modal.get_node_or_null("Margin/VBox/RulesList/Rule2/Margin/HBox/Desc")
	var rule3_desc = modal.get_node_or_null("Margin/VBox/RulesList/Rule3/Margin/HBox/Desc")
	var rule4_desc = modal.get_node_or_null("Margin/VBox/RulesList/Rule4/Margin/HBox/Desc")
	var rule5_desc = modal.get_node_or_null("Margin/VBox/RulesList/Rule5/Margin/HBox/Desc")

	assert(rule1_desc != null and "30 Martian Sols" in rule1_desc.text, "Rule 1 Objective verified")
	assert(rule2_desc != null and "Energy, Oxygen, Shield, Health, Food, and Water" in rule2_desc.text, "Rule 2 6 Resources verified")
	assert(rule3_desc != null and "400 mSv" in rule3_desc.text, "Rule 3 Radiation Limit verified")
	assert(rule4_desc != null and "Astro-Bot" in rule4_desc.text, "Rule 4 Astro-Bot Hint advice verified")
	assert(rule5_desc != null and "6 Mission Achievements" in rule5_desc.text, "Rule 5 Achievements verified")
	print("✓ All 5 game rules successfully verified inside HowToPlayModal!")

	# 4. Test Closing Modal
	diag._on_close_modal_pressed()
	assert(modal.visible == false, "Modal must close on close button")
	print("✓ 'HOW TO PLAY' modal closes cleanly!")

	# 5. Test START MISSION button transition
	var signal_box = [false]
	diag.intro_finished.connect(func(): signal_box[0] = true)
	diag._on_start_mission_pressed()
	assert(signal_box[0] == true, "intro_finished must be emitted on START MISSION")
	print("✓ 'START MISSION ▶' cleanly emits intro_finished signal!")

	diag.queue_free()

	print("==================================================")
	print("ALL 'HOW TO PLAY' & BUTTON TESTS PASSED!")
	print("==================================================")
	quit()

