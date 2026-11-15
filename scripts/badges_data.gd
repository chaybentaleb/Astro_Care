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
		"requirement": "Keep crew health >= 70% across all astronaut health dilemmas (Events 9-14)."
	},
	{
		"id": "badge_dosimetry_master",
		"title": "Dosimetry Master",
		"icon": "☢️",
		"category": "NASA RADLAB",
		"desc": "Navigate deep-space Galactic Cosmic Rays keeping cumulative radiation exposure under 40 mSv.",
		"requirement": "Maintain total radiation < 40.0 mSv through RadLab dosimetry events (Events 15-18)."
	},
	{
		"id": "badge_martian_botanist",
		"title": "Martian Botanist",
		"icon": "🌱",
		"category": "CSA AGRICULTURE",
		"desc": "Successfully cultivate hydroponic crops and reclaim water in the closed-loop greenhouse.",
		"requirement": "Complete greenhouse cultivation and water recycling events (Events 19, 21, 24)."
	},
	{
		"id": "badge_stem_scholar",
		"title": "STEM Science Scholar",
		"icon": "🎓",
		"category": "CSA STEM",
		"desc": "Demonstrate space science knowledge by answering all CSA STEM quizzes correctly.",
		"requirement": "Answer all CSA STEM quiz events (Events 25, 26, 27) correctly."
	},
	{
		"id": "badge_mars_commander",
		"title": "Legendary Mars Commander",
		"icon": "🏆",
		"category": "GRAND EXPEDITION",
		"desc": "Survive the entire 30-Sol Martian expedition with an S or A Commander Rating.",
		"requirement": "Complete all 30 mission events and earn S or A commander rating."
	}
]

static func get_all_badges() -> Array[Dictionary]:
	return BADGES

static func get_badge_by_id(badge_id: String) -> Dictionary:
	for b in BADGES:
		if b.get("id", "") == badge_id:
			return b
	return {}
