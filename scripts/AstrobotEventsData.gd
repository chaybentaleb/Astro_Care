class_name AstrobotEventsData
extends RefCounted
## Static data script containing structured dialogue, mood, and hint for all 30 mission events.
## Usage: var data = AstrobotEventsData.get_event(1)
##        print(data.mood, data.dialogue, data.hint)

const EVENTS: Dictionary = {
	# ======================================================================
	# DONKI — Space Weather (Events 1–8)
	# ======================================================================
	1: {
		"category": "DONKI",
		"title": "Minor Solar Flare",
		"mood": "Critical",
		"dialogue": "Commander! Small solar flare detected! Radio interference is spiking. Take evasive action!",
		"hint": "Hint: Shields protect us, but the shelter avoids heavy energy loss if power is tight!"
	},
	2: {
		"category": "DONKI",
		"title": "Major Solar Flare",
		"mood": "Critical",
		"dialogue": "EMERGENCY! Massive solar flare heading right at us! Protect the crew immediately!",
		"hint": "Hint: Full shield burns energy fast, but the shelter exposes crew to higher radiation!"
	},
	3: {
		"category": "DONKI",
		"title": "Solar Particle Cloud",
		"mood": "Critical",
		"dialogue": "Particle cloud incoming from the Sun! Our hull is taking pressure, Commander!",
		"hint": "Hint: Turning off machines saves power but raises radiation risks significantly."
	},
	4: {
		"category": "DONKI",
		"title": "Magnetic Disturbance",
		"mood": "Critical",
		"dialogue": "Magnetic disturbance detected! The base lights are flickering across all modules!",
		"hint": "Hint: Standby mode preserves core energy reserves from frying out."
	},
	5: {
		"category": "DONKI",
		"title": "Solar Particle Rain",
		"mood": "Critical",
		"dialogue": "High-speed solar particle rain! Radiation levels are climbing fast!",
		"hint": "Hint: Radiation is hitting red zones—maximum shield lowers exposure best!"
	},
	6: {
		"category": "DONKI",
		"title": "Solar Wind Wave",
		"mood": "Warning",
		"dialogue": "Warning! Solar wind wave shaking our external sensors. Telemetry is fluctuating.",
		"hint": "Hint: Manual checks cost precious oxygen instead of heavy energy."
	},
	7: {
		"category": "DONKI",
		"title": "Fast Solar Wind",
		"mood": "Warning",
		"dialogue": "Fast solar wind is scrambling our communication antennas. Stand by.",
		"hint": "Hint: Backup antenna keeps us online without draining life support."
	},
	8: {
		"category": "DONKI",
		"title": "Radiation Belt Expansion",
		"mood": "Critical",
		"dialogue": "Radiation belts are expanding around our orbit! We need to shield up.",
		"hint": "Hint: Protecting the satellite preserves tech integrity against radiation."
	},

	# ======================================================================
	# OSDR — Astronaut Health (Events 9–14)
	# ======================================================================
	9: {
		"category": "OSDR",
		"title": "Sleep Quality Decline",
		"mood": "Warning",
		"dialogue": "OSDR bio-metrics show poor sleep quality. The crew is getting exhausted.",
		"hint": "Hint: Soft lighting is an efficient way to recover health before tomorrow!"
	},
	10: {
		"category": "OSDR",
		"title": "Muscle Degradation",
		"mood": "Warning",
		"dialogue": "Muscle mass degradation detected by OSDR. Time for mandatory physical activity.",
		"hint": "Hint: Both options give great health boosts, but check oxygen levels first."
	},
	11: {
		"category": "OSDR",
		"title": "Bone Density Loss",
		"mood": "Warning",
		"dialogue": "Bone density metrics are dropping in microgravity. We must keep moving!",
		"hint": "Hint: Harness jumping costs oxygen, vibrating platforms drain energy."
	},
	12: {
		"category": "OSDR",
		"title": "Crew Illness",
		"mood": "Warning",
		"dialogue": "Health alert: An astronaut is feeling under the weather in closed quarters.",
		"hint": "Hint: Medicine costs food and energy, resting alone costs oxygen."
	},
	13: {
		"category": "OSDR",
		"title": "Low Morale",
		"mood": "Warning",
		"dialogue": "Crew morale is low. Being so far from Earth is weighing on their minds.",
		"hint": "Hint: Psychological stress is spiking; both choices restore crew health."
	},
	14: {
		"category": "OSDR",
		"title": "Exercise Block",
		"mood": "Warning",
		"dialogue": "Scheduled exercise block is active. Let's keep the crew in peak condition.",
		"hint": "Hint: Hard workouts give maximum health points if reserves can handle it."
	},

	# ======================================================================
	# RadLab — Radiation (Events 15–18)
	# ======================================================================
	15: {
		"category": "RadLab",
		"title": "Green Metrics",
		"mood": "Optimal",
		"dialogue": "All RadLab metrics are green and stable today, Commander. Peaceful skies!",
		"hint": "Hint: Use this calm window to check shields and lower radiation safely."
	},
	16: {
		"category": "RadLab",
		"title": "Elevated Radiation Sector",
		"mood": "Warning",
		"dialogue": "RadLab warning: We are drifting through an elevated radiation sector.",
		"hint": "Hint: Turning on the shield lowers radiation more effectively than staying inside."
	},
	17: {
		"category": "RadLab",
		"title": "Cosmic Ray Shielding",
		"mood": "Warning",
		"dialogue": "We need extra shielding for the crew quarters against cosmic rays.",
		"hint": "Hint: Mars soil saves water resources while shielding quarters."
	},
	18: {
		"category": "RadLab",
		"title": "Dosimeter Alarm",
		"mood": "Critical",
		"dialogue": "DOSIMETER ALARM! Radiation sensors are beeping loudly in the corridor!",
		"hint": "Hint: Emergency shield minimizes radiation spikes instantly!"
	},

	# ======================================================================
	# CSA — Food & Base (Events 19–24)
	# ======================================================================
	19: {
		"category": "CSA",
		"title": "Greenhouse Online",
		"mood": "Optimal",
		"dialogue": "Greenhouse systems online! Time to select our primary cultivation crop, Commander.",
		"hint": "Hint: Lettuce is fast for immediate food, tomatoes yield more but take time!"
	},
	20: {
		"category": "CSA",
		"title": "Base Relocation",
		"mood": "Critical",
		"dialogue": "Base integrity compromised! We must relocate to a new site on the Mars map immediately!",
		"hint": "Hint: Choose based on what resource you need most—water income or radiation protection!"
	},
	21: {
		"category": "CSA",
		"title": "Water Recycling Peak",
		"mood": "Optimal",
		"dialogue": "Water recycling systems are at peak efficiency for the greenhouse crops.",
		"hint": "Hint: Full power recycling yields massive food and water bonuses."
	},
	22: {
		"category": "CSA",
		"title": "Greenhouse Mold",
		"mood": "Warning",
		"dialogue": "Bio-hazard alert: Mold is spreading across the greenhouse plants.",
		"hint": "Hint: Cleaning saves our food crops from complete destruction."
	},
	23: {
		"category": "CSA",
		"title": "Low Food Stores",
		"mood": "Warning",
		"dialogue": "Food stores are running low, Commander. We need to regulate consumption.",
		"hint": "Hint: Small portions save food but slightly hurt crew health."
	},
	24: {
		"category": "CSA",
		"title": "Potato Cultivation",
		"mood": "Optimal",
		"dialogue": "Special potato strains are thriving in our Mars soil tests!",
		"hint": "Hint: Planting a lot gives a huge food boost for deep space survival."
	},

	# ======================================================================
	# CSA STEM — Quizzes (Events 25–27)
	# ======================================================================
	25: {
		"category": "STEM",
		"title": "Water Radiation Quiz",
		"mood": "Science",
		"dialogue": "Querying NASA database: Water molecules can help shield against radiation. True or False?",
		"hint": "Hint: Hydrogen-rich molecules like water act as excellent radiation absorbers!"
	},
	26: {
		"category": "STEM",
		"title": "Exercise in Space Quiz",
		"mood": "Science",
		"dialogue": "Scientific query: Why do astronauts maintain a strict daily workout routine in space?",
		"hint": "Hint: Microgravity causes rapid muscle atrophy and bone density loss."
	},
	27: {
		"category": "STEM",
		"title": "Solar Storms Quiz",
		"mood": "Science",
		"dialogue": "Trivia query: Can the Sun send massive clouds of charged particles into deep space?",
		"hint": "Hint: Think about solar storms and coronal mass ejections!"
	},

	# ======================================================================
	# Mars Trek / Base (Events 28–30)
	# ======================================================================
	28: {
		"category": "MARS",
		"title": "Dust Storm",
		"mood": "Warning",
		"dialogue": "Martian dust storm blocking the Sun! Solar panel efficiency is plummeting.",
		"hint": "Hint: Cleaning panels restores power generation before batteries die."
	},
	29: {
		"category": "MARS",
		"title": "Cold Mars Night",
		"mood": "Warning",
		"dialogue": "Mars nights are very cold. The base needs extra heat and solar panels sleep.",
		"hint": "Hint: Generators burn oxygen and energy—make sure you have enough backup."
	},
	30: {
		"category": "MARS",
		"title": "Hull Breach",
		"mood": "Critical",
		"dialogue": "CRITICAL BREACH! Pssshhh! A hull puncture is leaking oxygen into space!",
		"hint": "Hint: Immediate action required! Plug the hull breach before oxygen hits zero!"
	},
}


## Returns the event data dictionary for a given event number (1–30).
## Returns null if the event number is invalid.
static func get_event(event_number: int) -> Dictionary:
	if EVENTS.has(event_number):
		return EVENTS[event_number]
	push_warning("AstrobotEventsData: Invalid event number %d" % event_number)
	return {}


## Returns the mood string for a given event number.
static func get_mood(event_number: int) -> String:
	var data := get_event(event_number)
	return data.get("mood", "Unknown")


## Returns the dialogue string for a given event number.
static func get_dialogue(event_number: int) -> String:
	var data := get_event(event_number)
	var dialogue: String = data.get("dialogue", "")
	
	# Enhance dialogue with real-time parameters if SpaceWeatherAPI is active
	if Engine.get_main_loop() and Engine.get_main_loop().root and Engine.get_main_loop().root.has_node("SpaceWeatherAPI"):
		var api = Engine.get_main_loop().root.get_node_or_null("SpaceWeatherAPI")
		if api and api.is_live_data_available:
			if event_number == 1 and not api.live_parameters.solar_flare.class_type.is_empty():
				return "Commander! Live NASA DONKI alert: Class %s solar flare detected! Radio interference is spiking. Take evasive action!" % api.live_parameters.solar_flare.class_type
			elif event_number == 3 and api.live_parameters.cme.speed > 0:
				return "Live NASA telemetry! CME plasma cloud measured at %d km/s incoming from the Sun! Hull under pressure, Commander!" % api.live_parameters.cme.speed
			elif event_number == 4 and api.live_parameters.geomagnetic_storm.kp_index > 0:
				return "Active geomagnetic storm detected with planetary Kp %.1f! Base lights and buslines are flickering!" % api.live_parameters.geomagnetic_storm.kp_index

	return dialogue


## Returns the hint string for a given event number.
static func get_hint(event_number: int) -> String:
	var data := get_event(event_number)
	return data.get("hint", "")


## Returns the category string for a given event number.
static func get_category(event_number: int) -> String:
	var data := get_event(event_number)
	return data.get("category", "")


## Returns the total number of events.
static func get_event_count() -> int:
	return EVENTS.size()
