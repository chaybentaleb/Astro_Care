extends SceneTree

func _init() -> void:
	print("==================================================")
	print("STARTING UI SCALING & PADDING VERIFICATION...")
	print("==================================================")

	# 1. Verify Project Settings
	var width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var mode = ProjectSettings.get_setting("display/window/size/mode")
	var stretch_mode = ProjectSettings.get_setting("display/window/stretch/mode")
	var stretch_aspect = ProjectSettings.get_setting("display/window/stretch/aspect")

	print("Viewport Base Size: %s x %s" % [width, height])
	assert(width == 1920 and height == 1080, "Base resolution must be 1920x1080")

	print("Window Display Mode: %s (Fullscreen=3)" % mode)
	assert(mode == 3, "Window mode must be set to 3 (Fullscreen)")

	print("Stretch Mode: %s, Aspect: %s" % [stretch_mode, stretch_aspect])
	assert(stretch_mode == "canvas_items", "Stretch mode must be canvas_items")
	assert(stretch_aspect == "expand" or stretch_aspect == "keep", "Stretch aspect must be expand or keep")
	print("✓ Project Settings Fullscreen & Scaling verified!")

	# 2. Verify Scene Hierarchy & Anchors
	var donki_scene = load("res://scenes/donki_event_system.tscn")
	assert(donki_scene != null, "Failed to load donki_event_system.tscn")
	var instance = donki_scene.instantiate()

	var root_control: Control = instance.get_node_or_null("RootControl")
	assert(root_control != null, "RootControl node missing")
	print("RootControl anchors_preset: %d (PRESET_FULL_RECT=15)" % root_control.anchors_preset)
	assert(root_control.anchors_preset == Control.PRESET_FULL_RECT, "RootControl must use PRESET_FULL_RECT (15)")

	# Verify Main MarginContainer
	var margin_container: MarginContainer = root_control.get_node_or_null("MainMarginContainer")
	assert(margin_container != null, "MainMarginContainer missing under RootControl")

	var m_left = margin_container.get_theme_constant("margin_left")
	var m_right = margin_container.get_theme_constant("margin_right")
	var m_top = margin_container.get_theme_constant("margin_top")
	var m_bottom = margin_container.get_theme_constant("margin_bottom")

	print("MainMarginContainer Margins -> Left: %d, Right: %d, Top: %d, Bottom: %d" % [m_left, m_right, m_top, m_bottom])
	assert(m_left == 40 and m_right == 40, "Horizontal margins must be 40")
	assert(m_top == 25 and m_bottom == 25, "Vertical margins must be 25")
	print("✓ MainMarginContainer generous padding (40, 25, 40, 25) verified!")

	# Verify autowrap on key labels
	var title_lbl: Label = instance.get_node_or_null("%EventTitle")
	var desc_lbl: Label = instance.get_node_or_null("%EventScenario")
	var choice_a_lbl: Label = instance.get_node_or_null("%ChoiceAText")
	var choice_b_lbl: Label = instance.get_node_or_null("%ChoiceBText")

	assert(title_lbl != null, "%EventTitle missing")
	assert(desc_lbl != null, "%EventScenario missing")

	print("EventTitle autowrap_mode: %d (AUTOWRAP_WORD_SMART=3)" % title_lbl.autowrap_mode)
	print("EventScenario autowrap_mode: %d (AUTOWRAP_WORD_SMART=3)" % desc_lbl.autowrap_mode)

	assert(title_lbl.autowrap_mode == TextServer.AUTOWRAP_WORD_SMART, "EventTitle must have AUTOWRAP_WORD_SMART")
	assert(desc_lbl.autowrap_mode == TextServer.AUTOWRAP_WORD_SMART, "EventScenario must have AUTOWRAP_WORD_SMART")
	if choice_a_lbl:
		assert(choice_a_lbl.autowrap_mode == TextServer.AUTOWRAP_WORD_SMART, "ChoiceAText must have AUTOWRAP_WORD_SMART")
	if choice_b_lbl:
		assert(choice_b_lbl.autowrap_mode == TextServer.AUTOWRAP_WORD_SMART, "ChoiceBText must have AUTOWRAP_WORD_SMART")

	print("✓ Autowrap on title, description, and choice labels verified!")
	print("==================================================")
	print("ALL UI SCALING, FULLSCREEN & PADDING CHECKS PASSED!")
	print("==================================================")

	instance.free()
	quit()

