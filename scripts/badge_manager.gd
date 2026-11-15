class_name BadgeManagerClass
extends Node

## BadgeManager — Autoload singleton that tracks badge unlock state,
## evaluates conditions after each decision, and emits signals on unlock.
## Register as autoload "BadgeManager" in project.godot.

signal badge_unlocked(badge_id: String, badge_title: String, badge_icon: String)

# ─── Persistent unlock state ────────────────────────────────────────
var unlocked: Dictionary = {
	"badge_solar_shield": false,
	"badge_flight_surgeon": false,
	"badge_dosimetry_master": false,
	"badge_martian_botanist": false,
	"badge_stem_scholar": false,
	"badge_mars_commander": false,
}

# ─── Progress metrics tracked across decisions ──────────────────────
var min_health_ever: int = 100        # lowest health seen (for Flight Surgeon)
var donki_events_survived: int = 0    # count of DONKI events (1-8) survived
var csa_agri_events_completed: Array[int] = []  # IDs of completed agriculture events
var stem_correct_count: int = 0       # STEM quiz correct answers
var stem_total_count: int = 0         # STEM quiz total attempts

# Audio
var sfx_badge_unlock: AudioStream = null
var _audio_player: AudioStreamPlayer = null

func _ready() -> void:
	# Load badge unlock sound
	if ResourceLoader.exists("res://assets/audios/badge_unlock.wav"):
		sfx_badge_unlock = load("res://assets/audios/badge_unlock.wav")
	elif ResourceLoader.exists("res://assets/audio/sound effects/success.mp3.mp3"):
		sfx_badge_unlock = load("res://assets/audio/sound effects/success.mp3.mp3")

	# Create a dedicated AudioStreamPlayer for badge sounds
	_audio_player = AudioStreamPlayer.new()
	_audio_player.bus = "Master"
	add_child(_audio_player)

func reset() -> void:
	for key in unlocked.keys():
		unlocked[key] = false
	min_health_ever = 100
	donki_events_survived = 0
	csa_agri_events_completed.clear()
	stem_correct_count = 0
	stem_total_count = 0

func is_unlocked(badge_id: String) -> bool:
	return unlocked.get(badge_id, false)

func get_unlocked_count() -> int:
	var count: int = 0
	for v in unlocked.values():
		if v:
			count += 1
	return count

# ─── Called after each decision to update tracking & evaluate ───────
func on_decision_made(event_id: int, choice_key: String, stats: Dictionary, decision_history: Array[Dictionary]) -> void:
	var health: int = stats.get("health", 100)
	var radiation: float = float(stats.get("radiation", 0.0))
	var events_completed: int = stats.get("events_completed", 0)
	var score: int = stats.get("score", 0)

	# Track minimum health ever seen
	if health < min_health_ever:
		min_health_ever = health

	# Track DONKI events survived (event IDs 1-8)
	if event_id >= 1 and event_id <= 8:
		donki_events_survived += 1

	# Track CSA Agriculture events (IDs 19, 21, 24)
	if event_id in [19, 21, 24]:
		if event_id not in csa_agri_events_completed:
			csa_agri_events_completed.append(event_id)

	# Track STEM quiz answers (IDs 25, 26, 27)
	# "Correct" = choice A for STEM quizzes (the correct scientific answer)
	if event_id in [25, 26, 27]:
		stem_total_count += 1
		if choice_key.to_upper() == "A":
			stem_correct_count += 1

	# ─── Evaluate each badge ─────────────────────────────────────
	_check_badge("badge_solar_shield", func():
		# Survived all 8 DONKI events (1-8)
		return donki_events_survived >= 8
	)

	_check_badge("badge_flight_surgeon", func():
		# Health never dropped below 70% AND completed OSDR events (through event 14)
		return events_completed >= 14 and min_health_ever >= 70
	)

	_check_badge("badge_dosimetry_master", func():
		# Radiation strictly under 40 mSv by end of RadLab (through event 18)
		return events_completed >= 18 and radiation < 40.0
	)

	_check_badge("badge_martian_botanist", func():
		# Successfully completed greenhouse events 19, 21, 24
		return 19 in csa_agri_events_completed and 21 in csa_agri_events_completed and 24 in csa_agri_events_completed
	)

	_check_badge("badge_stem_scholar", func():
		# Answered all 3 STEM quizzes correctly
		return stem_total_count >= 3 and stem_correct_count >= 3
	)

	_check_badge("badge_mars_commander", func():
		# Survived all 30 events with S or A rating
		if events_completed >= 30:
			# Check rating based on final stats
			return (health >= 60 and radiation < 80.0 and stats.get("energy", 0) >= 15 
					and stats.get("food", 0) >= 15 and stats.get("water", 0) >= 25)
		return false
	)

func _check_badge(badge_id: String, condition: Callable) -> void:
	if unlocked.get(badge_id, false):
		return  # Already unlocked

	if condition.call():
		unlocked[badge_id] = true
		var badge_data = BadgesData.get_badge_by_id(badge_id)
		var title = badge_data.get("title", badge_id)
		var icon = badge_data.get("icon", "🏆")
		print("🏆 BADGE UNLOCKED: %s %s" % [icon, title])

		# Play triumphant unlock sound
		_play_unlock_sound()

		badge_unlocked.emit(badge_id, title, icon)

func _play_unlock_sound() -> void:
	if _audio_player and sfx_badge_unlock:
		_audio_player.stream = sfx_badge_unlock
		_audio_player.play()
