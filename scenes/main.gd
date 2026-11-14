extends Node2D

var dialogue_scene = preload("res://scenes/dialogue.tscn")
var donki_system_scene = preload("res://scenes/donki_event_system.tscn")

@onready var sound = $AudioStreamPlayer2D
@onready var red_flash = $"warning red/RedFlash"

var is_intro_active: bool = true
var dialogue_instance: Node = null

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if sound:
		sound.play()
	
	if red_flash:
		warning_flash()
	
	start_intro_dialogue()

func start_intro_dialogue() -> void:
	is_intro_active = true
	dialogue_instance = dialogue_scene.instantiate()
	add_child(dialogue_instance)
	if dialogue_instance.has_signal("intro_finished"):
		dialogue_instance.intro_finished.connect(_on_intro_finished)

func _on_intro_finished() -> void:
	if not is_intro_active:
		return
	is_intro_active = false
	if is_instance_valid(dialogue_instance):
		dialogue_instance.queue_free()
	start_donki_events()

func start_donki_events() -> void:
	is_intro_active = false
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
