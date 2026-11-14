extends Node2D

var dialogue_scene = preload("res://scenes/dialogue.tscn")
var donki_system_scene = preload("res://scenes/donki_event_system.tscn")

@onready var sound = $AudioStreamPlayer2D
@onready var red_flash = $"warning red/RedFlash"

var is_intro_active: bool = true
var dialogue_instance: Node = null

func _ready() -> void:
	if sound:
		sound.play()
	
	if red_flash:
		await warning_flash()
	
	await get_tree().create_timer(0.6).timeout
	
	if is_intro_active:
		await run_intro_dialogue()
	
	start_donki_events()

func _unhandled_input(event: InputEvent) -> void:
	# Allow quick skip on Space, Enter, or Click during intro
	if is_intro_active and (event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed)):
		is_intro_active = false
		if is_instance_valid(dialogue_instance):
			dialogue_instance.queue_free()
		start_donki_events()

func run_intro_dialogue() -> void:
	dialogue_instance = dialogue_scene.instantiate()
	add_child(dialogue_instance)

	var warning_icon = dialogue_instance.get_node_or_null("warning sign")
	var label1 = dialogue_instance.get_node_or_null("CanvasLayer/1")
	var label2 = dialogue_instance.get_node_or_null("CanvasLayer/2")
	var label3 = dialogue_instance.get_node_or_null("CanvasLayer/3")

	# Step 1: Warning icon + text 1
	if warning_icon: warning_icon.show()
	if label1: label1.show()
	if label2: label2.hide()
	if label3: label3.hide()
	await get_tree().create_timer(2.5).timeout
	if not is_intro_active: return

	# Step 2: Text 2 (Wake up Commander)
	if label1: label1.hide()
	if label2: label2.show()
	await get_tree().create_timer(2.5).timeout
	if not is_intro_active: return

	# Step 3: Text 3 (Every swipe you make...)
	if label2: label2.hide()
	if label3: label3.show()
	await get_tree().create_timer(2.5).timeout
	if not is_intro_active: return

	if is_instance_valid(dialogue_instance):
		dialogue_instance.queue_free()

func start_donki_events() -> void:
	is_intro_active = false
	# Ensure only one instance runs
	if get_node_or_null("DonkiEventSystem") == null:
		var donki_sys = donki_system_scene.instantiate()
		donki_sys.name = "DonkiEventSystem"
		add_child(donki_sys)

func warning_flash() -> void:
	if not red_flash:
		return
	for i in 3:
		var tween = create_tween()
		tween.tween_property(red_flash, "modulate:a", 0.6, 0.1)
		tween.tween_property(red_flash, "modulate:a", 0.0, 0.1)
		tween.tween_interval(0.3)
		await tween.finished
