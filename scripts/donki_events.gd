class_name DonkiEvents
extends RefCounted

## NASA DONKI (Space Weather Database Of Notifications, Knowledge, Information)
## Events 1 through 8 with exact resource impacts: Energy, Oxygen, Shield, Radiation in mSv.

static func get_all_events() -> Array[Dictionary]:
	return [
		{
			"id": 1,
			"title": "Small Solar Flare",
			"donki_code": "DONKI ALERT: FLR-C3.4 (Solar Flare)",
			"scenario": "Solar magnetometers detect a class C solar flare erupting from active region AR-3412. An ionization wavefront is sweeping through our forward telemetry arrays.",
			"bot_advice": "Astro-Bot: \"Minor coronal flare detected, Commander. Shield absorption will draw battery reserve, but the crew shelter will consume reserve oxygen.\"",
			"choice_a": {
				"label": "Turn on the shield",
				"effects": {
					"shield": -3,
					"energy": -4,
					"radiation": 1
				},
				"description": "Engage defensive deflector grid to deflect the solar blast."
			},
			"choice_b": {
				"label": "Go into the shelter",
				"effects": {
					"oxygen": -3,
					"radiation": 3
				},
				"description": "Order crew into storm shelter while leaving hull unshielded."
			}
		},
		{
			"id": 2,
			"title": "Big Solar Flare",
			"donki_code": "DONKI CRITICAL: FLR-X9.1 (Major Solar Flare)",
			"scenario": "WARNING: Extreme X-class solar flare detected. A colossal shockwave of energetic protons and hard X-rays is hurtling directly toward the Astro-Care at near light-speed.",
			"bot_advice": "Astro-Bot: \"Extreme flux incoming! Full shields will strain our power grid, but taking refuge inside the shelter exposes the ship to severe radiation leakage.\"",
			"choice_a": {
				"label": "Shield at full power",
				"effects": {
					"energy": -8,
					"shield": -8,
					"radiation": 15
				},
				"description": "Reroute all primary power to max out defensive shields."
			},
			"choice_b": {
				"label": "Everyone into the shelter",
				"effects": {
					"oxygen": -6,
					"energy": -2,
					"radiation": 40
				},
				"description": "Abandon posts and seal the entire crew inside the reinforced bunker."
			}
		},
		{
			"id": 3,
			"title": "Cloud from the Sun",
			"donki_code": "DONKI ALERT: CME-0819 (Coronal Mass Ejection)",
			"scenario": "A billion tons of superheated magnetized solar plasma have detached from the sun. The interplanetary CME cloud is expanding and set to engulf our orbital coordinates.",
			"bot_advice": "Astro-Bot: \"Dense coronal plasma cloud inbound! Reinforced shields will mitigate radiation, or we can shut down auxiliary systems to save hull integrity.\"",
			"choice_a": {
				"label": "Strengthen the shield",
				"effects": {
					"energy": -6,
					"shield": -6,
					"radiation": 5
				},
				"description": "Harmonize shield frequencies against ionized magnetized plasma."
			},
			"choice_b": {
				"label": "Turn off unneeded machines",
				"effects": {
					"energy": -3,
					"oxygen": -3,
					"radiation": 20
				},
				"description": "Power down non-critical deck systems and life-support compressors."
			}
		},
		{
			"id": 4,
			"title": "Magnetic Storm",
			"donki_code": "DONKI ALERT: GST-G4 (Severe Geomagnetic Storm)",
			"scenario": "Planetary magnetic oscillations have induced volatile voltage spikes across external buslines. Transformers and exterior sensors risk immediate blowout.",
			"bot_advice": "Astro-Bot: \"High electromagnetic induction detected! Disconnecting solar wings saves electronics, or we can isolate sensitive machinery directly.\"",
			"choice_a": {
				"label": "Put the solar panels on standby",
				"effects": {
					"energy": -8,
					"shield": -2
				},
				"description": "Retract and ground photovoltaic arrays to prevent circuit overload."
			},
			"choice_b": {
				"label": "Protect the machines",
				"effects": {
					"shield": -6,
					"energy": -4
				},
				"description": "Divert hull shield emitters to ground and insulate internal machinery."
			}
		},
		{
			"id": 5,
			"title": "Particle Rain",
			"donki_code": "DONKI CRITICAL: SEP-S3 (Solar Energetic Particle Event)",
			"scenario": "High-velocity relativistic protons and radioactive isotopes are penetrating the vessel's exterior skin. Radiation detectors trigger station-wide sirens.",
			"bot_advice": "Astro-Bot: \"Subatomic particle hail storm! The shelter will protect life but consume critical oxygen reserves, unless shields absorb the particle impacts.\"",
			"choice_a": {
				"label": "Run to the shelter",
				"effects": {
					"oxygen": -6,
					"energy": -3,
					"radiation": 30
				},
				"description": "Sprint to the inner citadel bunker to avoid primary particle bombardment."
			},
			"choice_b": {
				"label": "Maximum shield",
				"effects": {
					"energy": -8,
					"shield": -10,
					"radiation": 15
				},
				"description": "Overdrive electromagnetic deflection coils to scatter incoming particle shower."
			}
		},
		{
			"id": 6,
			"title": "Solar Wind Wave",
			"donki_code": "DONKI ALERT: IPS-1102 (Interplanetary Shockwave)",
			"scenario": "A fast compression shockwave in the solar wind strikes the bow. Exterior navigational telemetry freezes and attitude sensors fall out of calibration.",
			"bot_advice": "Astro-Bot: \"Sensor array desynchronized by solar wind shock. An automated system reboot will drain energy, or the crew can perform manual spacewalk checks.\"",
			"choice_a": {
				"label": "Restart the sensors",
				"effects": {
					"energy": -4,
					"shield": -1
				},
				"description": "Initiate high-power automated sensor cold reboot and diagnostic cycle."
			},
			"choice_b": {
				"label": "Check by hand",
				"effects": {
					"oxygen": -3,
					"energy": -1,
					"radiation": 1
				},
				"description": "Send crew members on EVA to manually inspect and align sensor housings."
			}
		},
		{
			"id": 7,
			"title": "Fast Solar Wind",
			"donki_code": "DONKI ALERT: HSS-CH22 (Coronal Hole High Speed Stream)",
			"scenario": "Solar wind velocity spikes past 750 km/s due to an open coronal hole stream. Thermal turbulence disrupts communications with Earth command.",
			"bot_advice": "Astro-Bot: \"High-speed stream turbulence buffeting communications! We can deploy high-gain backup transmitters, or endure the storm in silent running.\"",
			"choice_a": {
				"label": "Use the backup antenna",
				"effects": {
					"energy": -4
				},
				"description": "Power up redundant directional phased-array antenna to maintain link."
			},
			"choice_b": {
				"label": "Wait quietly",
				"effects": {
					"oxygen": -2,
					"shield": -2
				},
				"description": "Conserve power, reduce thrust, and weather out the atmospheric friction."
			}
		},
		{
			"id": 8,
			"title": "Radiation Belts",
			"donki_code": "DONKI ALERT: RBE-047 (Radiation Belt Enhancement)",
			"scenario": "The vessel's trajectory traverses compressed outer radiation belts filled with trapped relativistic electrons. Satellite link relay components face heavy degradation.",
			"bot_advice": "Astro-Bot: \"Final hazard sector! Trapped radiation belt electrons will degrade our satellite gear unless shielded, or we slow operations to reduce wear.\"",
			"choice_a": {
				"label": "Protect the satellite",
				"effects": {
					"energy": -5,
					"shield": -5,
					"radiation": 2
				},
				"description": "Deploy active magnetic shielding to safeguard external relay satellites."
			},
			"choice_b": {
				"label": "Work less",
				"effects": {
					"oxygen": -3,
					"energy": -2,
					"radiation": 5
				},
				"description": "Throttle non-essential station workload and rest the crew until passage clears."
			}
		}
	]

static func format_effects(effects: Dictionary) -> String:
	var parts: Array[String] = []
	if effects.has("energy"):
		var val = effects["energy"]
		parts.append("Energy %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("oxygen"):
		var val = effects["oxygen"]
		parts.append("Oxygen %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("shield"):
		var val = effects["shield"]
		parts.append("Shield %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("radiation"):
		var val = effects["radiation"]
		parts.append("+%d mSv" % val if val > 0 else "%d mSv" % val)
	return " | ".join(parts)

