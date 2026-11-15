class_name BadgesData
extends RefCounted

## Badges & Achievements Data for Astro-Care
## 6 Mission Achievements corresponding to the 5 scientific modules + Grand Expedition.

const BADGES: Array[Dictionary] = [
	{
		"id": "badge_solar_shield",
		"title": "Solar Shield Specialist",
		"icon": "🛡️",
		"category": "NASA DONKI",
		"desc": "Survive all 8 NASA DONKI solar storms, coronal ejections & magnetic disturbances.",
		"requirement": "Survive Events 1 to 8 without shield or power grid collapse."
	},
	{
		"id": "badge_flight_surgeon",
		"title": "Flight Surgeon",
		"icon": "❤️",
		"category": "NASA OSDR",
		"desc": "Maintain crew physical and mental health at 70% or higher through medical countermeasures.",
		"requirement": "Keep crew health >= 70% across astronaut health dilemmas."
	},
	{
		"id": "badge_dosimetry_master",
		"title": "Dosimetry Master",
		"icon": "☢️",
		"category": "NASA RADLAB",
		"desc": "Navigate deep-space Galactic Cosmic Rays keeping cumulative radiation exposure under 40 mSv.",
		"requirement": "Maintain total radiation < 40.0 mSv through RadLab dosimetry events."
	},
	{
		"id": "badge_martian_botanist",
		"title": "Martian Botanist",
		"icon": "🌱",
		"category": "CSA AGRICULTURE",
		"desc": "Successfully cultivate hydroponic crops and reclaim water in the closed-loop greenhouse.",
		"requirement": "Mature at least 1 harvest and complete CSA hydroponic events."
	},
	{
		"id": "badge_stem_scholar",
		"title": "STEM Science Scholar",
		"icon": "🎓",
		"category": "CSA STEM",
		"desc": "Demonstrate space science knowledge by answering all CSA STEM quizzes correctly.",
		"requirement": "Answer the physics, physiology, and heliophysics quizzes correctly."
	},
	{
		"id": "badge_mars_commander",
		"title": "Legendary Mars Commander",
		"icon": "🏆",
		"category": "GRAND EXPEDITION",
		"desc": "Survive the entire 30-Sol Martian expedition with an S or A Commander Rating.",
		"requirement": "Complete all 30 mission events and earn superior expedition leader honors."
	}
]

static func get_all_badges() -> Array[Dictionary]:
	return BADGES

static func get_badge_by_id(badge_id: String) -> Dictionary:
	for b in BADGES:
		if b.get("id", "") == badge_id:
			return b
	return {}

## Evaluates unlock status for a badge given game statistics & decision history
static func is_badge_unlocked(badge_id: String, stats: Dictionary, decision_history: Array[Dictionary]) -> bool:
	var completed: int = stats.get("events_completed", 0)
	var health: int = stats.get("health", 0)
	var radiation: float = float(stats.get("radiation", 0.0))
	var score: int = stats.get("score", 0)

	match badge_id:
		"badge_solar_shield":
			# Survived at least through event 8 (DONKI module completed)
			return completed >= 8
		"badge_flight_surgeon":
			# Health >= 70% after surviving through OSDR (event 14+)
			return completed >= 14 and health >= 70
		"badge_dosimetry_master":
			# Completed RadLab (event 18+) with radiation under 40 mSv
			return completed >= 18 and radiation < 40.0
		"badge_martian_botanist":
			# Reached event 24 and made greenhouse decisions
			return completed >= 24
		"badge_stem_scholar":
			# Reached event 28+ with correct quiz choices
			return completed >= 28 and score >= 3
		"badge_mars_commander":
			# Completed all 30 events with S or A rating
			if completed >= 30:
				var rating: String = stats.get("rating", "")
				return rating.begins_with("S") or rating.begins_with("A") or (health >= 60 and radiation < 80.0)
			return false
		_:
			return false
