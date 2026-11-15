class_name OsdrEvents
extends RefCounted

## NASA OSDR (Open Science Data Repository - Astronaut Health & Omics Studies)
## Events 9 through 14 affecting crew health, oxygen, energy, food, and water.

static func get_all_events() -> Array[Dictionary]:
	return [
		{
			"id": 9,
			"title": "Sleeping Badly",
			"category": "OSDR CIRCADIAN & NEURO-VESTIBULAR",
			"osdr_code": "OSDR-STUDY-0419: Crew Circadian Disruption",
			"scenario": "Microgravity and orbital sunrise cycles every 90 minutes have disrupted crew REM sleep. Astronauts report persistent insomnia and brain fog.",
			"astronaut_name": "Dr. Sarah Chen (Payload Specialist)",
			"astronaut_portrait": "res://assets/images/C1H.png",
			"bot_advice": "Astro-Bot: \"Melatonin rhythms are desynchronized. Blue-light filtering will draw electrical power, while synchronized cabin sleep cycles consume reserve oxygen.\"",
			"choice_a": {
				"label": "Soft light in the evening",
				"effects": {
					"energy": -3,
					"health": 5
				},
				"description": "Shift cabin LED illumination to low-intensity amber to stimulate natural melatonin synthesis."
			},
			"choice_b": {
				"label": "Nap together",
				"effects": {
					"oxygen": -2,
					"health": 4
				},
				"description": "Enforce a mandatory synchronized dark-cabin rest schedule for the entire crew."
			}
		},
		{
			"id": 10,
			"title": "Tired Muscles",
			"category": "OSDR MUSCULOSKELETAL BIOLOGY",
			"osdr_code": "OSDR-STUDY-0582: Postural Muscle Fiber Atrophy",
			"scenario": "Biomechanics telemetry indicates significant calf and spinal postural muscle atrophy from lack of gravity load. The crew complains of acute muscular fatigue.",
			"astronaut_name": "Commander Elena Rostova",
			"astronaut_portrait": "res://assets/images/C3H.png",
			"bot_advice": "Astro-Bot: \"Cardiovascular cycle training consumes aerobic oxygen, whereas high-resistance magnetic load machines draw power from our capacitors.\"",
			"choice_a": {
				"label": "Ride the bike",
				"effects": {
					"oxygen": -4,
					"energy": -2,
					"health": 8
				},
				"description": "Conduct high-cadence cycle ergometer sessions to stimulate cardiovascular and leg muscle tone."
			},
			"choice_b": {
				"label": "Use the exercise machine",
				"effects": {
					"energy": -5,
					"health": 8
				},
				"description": "Engage Advanced Resistive Exercise Device (ARED) for heavy resistance compound training."
			}
		},
		{
			"id": 11,
			"title": "Fragile Bones",
			"category": "OSDR SKELETAL OSTEOPENIA",
			"osdr_code": "OSDR-STUDY-0621: Trabecular Bone Demineralization",
			"scenario": "Urinary calcium assays reveal rapid bone mineral density loss in femur and lumbar vertebrae. Astronaut bone structures are becoming brittle.",
			"astronaut_name": "Chief Engineer Kenji Tanaka",
			"astronaut_portrait": "res://assets/images/C4H.png",
			"bot_advice": "Astro-Bot: \"Osteoclast activity is outpacing bone deposition. Harness impact jumping elevates respiratory rate, while acoustic vibrational therapy requires power.\"",
			"choice_a": {
				"label": "Jump with a harness",
				"effects": {
					"oxygen": -3,
					"health": 6
				},
				"description": "Perform tethered bungee plyometric jumps against the treadmill plate to trigger osteogenesis."
			},
			"choice_b": {
				"label": "Vibrating platform",
				"effects": {
					"energy": -5,
					"health": 6
				},
				"description": "Activate low-magnitude whole-body vibration transducer plate to mechanically stimulate bone tissue."
			}
		},
		{
			"id": 12,
			"title": "An Astronaut Has a Cold",
			"category": "OSDR IMMUNOLOGY & MICROBIOME",
			"osdr_code": "OSDR-STUDY-0733: Spaceflight Immune Dysregulation",
			"scenario": "Microgravity has suppressed T-cell activation. Astronaut C2 has contracted an aggressive rhinovirus with a severe fever and productive cough.",
			"astronaut_name": "Dr. Marcus Vance (Life Support Officer)",
			"astronaut_portrait": "res://assets/images/C2H.png",
			"bot_advice": "Astro-Bot: \"Pathogen shedding in closed environmental control is hazardous. Medical quarantine requires dedicated ventilation; pharmaceutical treatment expends nutrient stores.\"",
			"choice_a": {
				"label": "Let them rest alone",
				"effects": {
					"oxygen": -4,
					"health": 8
				},
				"description": "Seal the patient inside isolation quarters with dedicated HEPA micro-filtration."
			},
			"choice_b": {
				"label": "Give them medicine",
				"effects": {
					"energy": -2,
					"food": -1,
					"health": 5
				},
				"description": "Administer antiviral immuno-boosters alongside fortified emergency medical calorie rations."
			}
		},
		{
			"id": 13,
			"title": "Feeling Blue",
			"category": "OSDR BEHAVIORAL HEALTH & PSYCHOLOGY",
			"osdr_code": "OSDR-STUDY-0844: Confinement & Sensory Deprivation",
			"scenario": "Forty million miles away from home in absolute darkness, the crew is struggling with acute psychological isolation, nostalgia, and depressive mood shifts.",
			"astronaut_name": "Dr. Sarah Chen (Payload Specialist)",
			"astronaut_portrait": "res://assets/images/C1H.png",
			"bot_advice": "Astro-Bot: \"High cortisol levels impair operational decision-making. Communal gaming burns oxygen and power; establishing an Earth family video link taxes directional transmitters.\"",
			"choice_a": {
				"label": "Play games together",
				"effects": {
					"oxygen": -2,
					"energy": -2,
					"health": 6
				},
				"description": "Gather all crew members in the mess module for competitive board games and cooperative VR."
			},
			"choice_b": {
				"label": "Call family",
				"effects": {
					"energy": -4,
					"health": 6
				},
				"description": "Align high-gain laser transceiver to transmit personal encrypted video calls with Earth families."
			}
		},
		{
			"id": 14,
			"title": "Exercise Time",
			"category": "OSDR PHYSIOLOGICAL COUNTERMEASURES",
			"osdr_code": "OSDR-STUDY-0901: Daily Physiological Conditioning",
			"scenario": "Flight surgeons mandate daily physical maintenance to counter cardiovascular deconditioning and blood fluid shifts toward the head.",
			"astronaut_name": "Chief Engineer Kenji Tanaka",
			"astronaut_portrait": "res://assets/images/C4H.png",
			"bot_advice": "Astro-Bot: \"High-intensity training produces peak physical adaptations but consumes heavy life-support reserves. Gentle stretching conserves our stores.\"",
			"choice_a": {
				"label": "Hard workout",
				"effects": {
					"oxygen": -4,
					"energy": -3,
					"health": 8
				},
				"description": "Execute intense high-load circuit training at 85% VO2 max to maximize cardiac output and tone."
			},
			"choice_b": {
				"label": "Gentle stretching",
				"effects": {
					"oxygen": -1,
					"energy": -1,
					"health": 4
				},
				"description": "Perform guided low-exertion mobility, spinal decompression, and dynamic stretching."
			}
		}
	]

static func format_effects(effects: Dictionary) -> String:
	var parts: Array[String] = []
	if effects.has("health"):
		var val = effects["health"]
		parts.append("Health %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("energy"):
		var val = effects["energy"]
		parts.append("Energy %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("oxygen"):
		var val = effects["oxygen"]
		parts.append("Oxygen %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("food"):
		var val = effects["food"]
		parts.append("Food %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("water"):
		var val = effects["water"]
		parts.append("Water %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("shield"):
		var val = effects["shield"]
		parts.append("Shield %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("radiation"):
		var val = effects["radiation"]
		parts.append("+%d mSv" % val if val > 0 else "%d mSv" % val)
	return " | ".join(parts)

