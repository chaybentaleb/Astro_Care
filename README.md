# 🚀 Astro-Care

> **A Deep-Space & Martian Outpost Survival Management Game built with Godot 4.**

![Godot 4](https://img.shields.io/badge/Godot-4.7%2B-478cbf?logo=godotengine&logoColor=white)
![Genre](https://img.shields.io/badge/Genre-Sci--Fi%20Survival%20%2F%20Decision-blue)
![Data Sources](https://img.shields.io/badge/Scientific%20Data-NASA%20DONKI%20%7C%20OSDR%20%7C%20RadLab%20%7C%20CSA-0b3d91)

---

## 🌌 Overview

Forty million miles away from Earth, you command the deep-space vessel and planetary outpost **Astro-Care**. 

When solar storms, micrometeorites, atmospheric leaks, and life-support failures strike, you must make tactical command decisions balancing scarce resources against lethal cosmic hazards. Every protocol decision directly impacts your crew's survival.

Inspired by *Reigns*, *Out There*, and *FTL*, **Astro-Care** integrates real-world heliophysics, astronaut biology, and space exploration science derived from **NASA** and **CSA (Canadian Space Agency)** databases.

---

## ⚡ Core Resource Systems

Manage 7 vital life-support, vessel, and mission parameters:

| Resource | Icon | Description | Critical Threshold |
|:---|:---:|:---|:---:|
| **Energy** | ⚡ | Habitat power, deflector fields, heaters, and computing bus | **0% = Power Grid Collapse** |
| **Oxygen** | 🫁 | Pressurized cabin atmosphere and spacesuit reserves | **0% = Hypoxia / Suffocation** |
| **Deflector Shield** | 🛡️ | Magnetic and electrostatic cosmic particle deflectors | **0% = Hull Breach** |
| **Crew Health** | ❤️ | Physical conditioning, bone density, and viral immunity | **0% = Medical Incapacitation** |
| **Radiation Dose** | ☢️ | Cumulative ionizing radiation exposure in mSv | **≥ 100 mSv = Lethal Radiation Sickness** |
| **Food Rations** | 🍏 | Caloric food reserves and nutrient paste packs | **0 = Starvation** |
| **Water Supply** | 💧 | Potable water tanks, greywater recyclers, and ice stores | **0% = Critical Dehydration** |

---

## 🛰️ 30 Scientific Mission Events

The campaign features **30 scientifically grounded scenarios** divided into 5 major modules:

### 1. NASA DONKI: Space Weather & Solar Disturbances (Events 1–8)
* **1. Small Solar Flare**: Class-C flare ionization wavefront.
* **2. Big Solar Flare**: Emergency X-class coronal shockwave.
* **3. Cloud from the Sun**: Massive coronal mass ejection (CME) plasma cloud.
* **4. Magnetic Storm**: High-induction geomagnetic storm threatening electronics.
* **5. Particle Rain**: Relativistic solar energetic particle (SEP) bombardment.
* **6. Solar Wind Wave**: Interplanetary shockwave disrupting telemetry.
* **7. Fast Solar Wind**: High-speed coronal hole stream buffeting communication.
* **8. Radiation Belts**: Orbital passage through compressed Van Allen radiation belts.

### 2. NASA OSDR: Astronaut Health & Countermeasures (Events 9–14)
* **9. Sleeping Badly**: Circadian rhythm disruption & melatonin intervention.
* **10. Tired Muscles**: Postural muscle atrophy & resistive ARED training.
* **11. Fragile Bones**: Trabecular bone demineralization & acoustic vibrational therapy.
* **12. An Astronaut Has a Cold**: Spaceflight immune dysregulation & medical isolation.
* **13. Feeling Blue**: Deep-space psychological isolation & Earth laser comms.
* **14. Exercise Time**: Daily cardiovascular interval training vs. mobility stretching.

### 3. NASA RadLab: Galactic Cosmic Rays & Dosimetry (Events 15–18)
* **15. Quiet Day**: Baseline Galactic Cosmic Ray (GCR) background accumulation (+10.5 mSv).
* **16. More Radiation Zone**: High-flux radiation belt anomaly penetration.
* **17. A Thicker Wall**: Polyethylene water-wall shielding vs. Martian regolith blocks.
* **18. Dosimeter Alarm**: Active wearable dosimeter threshold breach during EVA.

### 4. CSA Agriculture: Greenhouse Hydroponics & Recycling (Events 19, 21–24)
* **19. Grow Food (Pick a Crop)**: 3-Choice crop rotation with turn-based delayed harvests:
  * *Lettuce*: Low cost, +10 Food after 1 turn.
  * *Potatoes*: Moderate cost, +18 Food after 2 turns.
  * *Dwarf Tomatoes*: High nutrient density, +26 Food after 3 turns.
* **21. Recycling Water**: Vapor compression distillation & nutrient sludge recovery.
* **22. Mold in the Greenhouse**: Hydroponic fungal outbreak disinfection.
* **23. Low on Food**: Caloric intake rationing protocols.
* **24. Mars Potatoes**: Regolith perchlorate-washed tuber farming.

### 5. CSA STEM Quizzes & Mars Trek Base Survival (Events 20, 25–30)
* **20. Time to Move (Mars Map Selection)**: 4-Way Outpost Site Selection with persistent per-turn modifiers:
  * *Jezero Crater*: +3 Science Discovery Score / turn.
  * *Arcadia Planitia*: +3 Water ice extraction / turn.
  * *Deuteronilus Mensae*: +4 Water / turn, -2 Heating Energy / turn.
  * *Hellas Basin*: Radiation x0.85, Dust x1.5.
* **25. Quiz: Does Water Protect?**: Hydrogen radiation shielding physics.
* **26. Quiz: Why Exercise?**: Zero-gravity musculoskeletal countermeasure science.
* **27. Quiz: The Sun**: Heliophysics 11-year solar cycle trivia.
* **28. Dust Storm on Mars**: Severe global iron-oxide solar panel obscuration.
* **29. The Cold Mars Night**: -125°C nocturnal sub-zero thermal freeze.
* **30. Oxygen Leak**: High-pressure composite hull micrometeorite puncture.

---

## 🎮 How to Play

1. **Clone the repository**:
   ```bash
   git clone https://github.com/larptime/Astro_Care.git
   cd Astro_Care
   ```
2. **Open in Godot Engine 4** (Godot 4.6+ or 4.7+ compatible).
3. **Press F5** or run `scenes/main.tscn`.
4. **Choose your Play Mode**:
   * `ALL (1-30)`: Full 30-event grand expedition campaign.
   * `DONKI (1-8)`: Space weather & solar storms.
   * `OSDR (9-14)`: Astronaut health & medical dilemmas.
   * `RADLAB (15-18)`: Cosmic ray dosimetry.
   * `CSA (19-24)`: Greenhouse farming & water reclamation.
   * `MARS (20, 25-30)`: Base site relocation, STEM quizzes & habitat survival.

---

## 🛠️ Project Structure

```
Astro_Care/
├── project.godot                # Godot 4 project configuration
├── README.md                    # Project documentation
├── scenes/
│   ├── main.tscn & main.gd      # Intro cinematic & scene manager
│   ├── donki_event_system.tscn  # Main interactive event terminal & HUD
│   ├── dialogue.tscn            # Holographic intro dialogue
│   ├── characters.tscn          # Crew member sprite assets
│   └── astro_bot.tscn           # Astro-Bot sprite assets
├── scripts/
│   ├── game_manager.gd          # Core state machine, resource logic & win/loss checks
│   ├── donki_event_system.gd    # Event dialog UI controller
│   ├── donki_events.gd          # Events 1–8 data
│   ├── osdr_events.gd           # Events 9–14 data
│   ├── radlab_events.gd         # Events 15–18 data
│   ├── csa_events.gd            # Events 19, 21–24 data
│   ├── mars_stem_events.gd      # Events 20, 25–30 data
│   └── test_*.gd                # Automated headless verification test suites
└── assets/
    ├── audio/                   # Sound effects & alarms
    ├── fonts/                   # Nasalization sci-fi font
    └── images/                  # Martian base backgrounds, UI frames & character sprites
```

---

## 🧪 Automated Testing

All events and game loops include headless test suites runnable via the Godot command line:

```bash
godot --headless --path . -s res://scripts/test_mars_stem_events.gd
```

---

## 📜 License & Acknowledgments

* Developed with **Godot Engine**.
* Educational scenarios inspired by open scientific datasets from **NASA DONKI**, **NASA OSDR**, **NASA RadLab**, and the **Canadian Space Agency (CSA)**.
