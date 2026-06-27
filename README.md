# Sagrada Familia Lamp

Turn the lamps from the Sagrada Familia central tower inauguration into a smart nightstand light (or print your own Gaudí Lamp from scratch).

Context and hacking journey [on this thread](https://x.com/merybenavente/status/2065018276019589430). Thanks to [David Marcos](https://github.com/nozamdavid) for his central contributions to the 3D models.

![Sagrada Familia Lamp](3d_models/lamp_photo.jpg)

## Projects

### 1. Hourly chime — make it glow every hour
Use an ESP32 + IR LED to fire a warm white fade effect at the top of every hour (I restricted mine 9am–10pm). The ESP32 syncs time via NTP once a day and deep-sleeps between chimes.

**What you need**
- The original PixMob lamp from the event
- ESP32: I bought one Seeed XIAO ESP32-C3, pre-soldered (~$11) for development and then Seeed XIAO ESP32-S3 unsoldered for assembling the final ones
- IR LED 940nm (emitter) — comes in packs (~$1)
- ~200Ω resistor (anything between 100–330Ω should work)
- 3.7V LiPo with JST connector (~500mAh is enough) (~$7)
- Breadboard + jumpers for prototyping (optional, but highly recommended)

**Wiring:** D10 → resistor → IR LED (+) → IR LED (−) → GND. For the LiPo battery, connect B+/B− pads to the XIAO pads (red +, black −).

**Setup:** flash [`hour_cue.ino`](hour_cue.ino) via the Arduino IDE (remember to update your WiFi credentials and timezone).

Now, every time your controller is near the lamp, it will chime on the clock!

### 2. IR remote with an on/off button
A physical button that toggles the lamp on and off via IR. The ESP32 deep-sleeps and wakes on button press.
[TODO include picture]

**What you need**
- The original PixMob lamp from the event
- Print the remote case (TODO add link)
- ESP32: I bought one Seeed XIAO ESP32-C3, pre-soldered (~$11) for development and then Seeed XIAO ESP32-S3 unsoldered for assembling the final ones
- IR LED 940nm (emitter) — comes in packs (~$1)
- ~200Ω resistor (anything between 100–330Ω should work)
- A button (the one compatible with the remote 3d on this repo is [this one](https://www.amazon.com/20pcs-Momentary-Tactile-Button-Switch/dp/B008DGA9UY/ref=rvi_d_sccl_2/146-0968602-7795457?pd_rd_w=mRcek&content-id=amzn1.sym.f5690a4d-f2bb-45d9-9d1b-736fee412437&pf_rd_p=f5690a4d-f2bb-45d9-9d1b-736fee412437&pf_rd_r=3ZZ53QT213197EXESTWM&pd_rd_wg=qUlRE&pd_rd_r=f4440f52-105d-41a2-9eda-57ad9240f329&pd_rd_i=B008DGA9UY&psc=1)) [TODO update with link to the specs instead of amazon]
- 3.7V LiPo with JST connector (~500mAh is enough) (~$7)
- Breadboard + jumpers for prototyping (optional, but highly recommended)

**Wiring:** D10 → One leg of the button → Diagonal Leg of that one → resistor → IR LED (+) → IR LED (−) → GND. For the LiPo battery, connect B+/B− pads to the XIAO pads (red +, black −).

**Setup:** flash [`remote.ino`](remote.ino) via the Arduino IDE.

### 3. Print your own lamp and include a smart light
If you want HomeKit / Siri control, the easier path is printing your own lamp and putting a smart bulb inside (simpler than trying to keep the original PixMob wired up).

I state the obvious: you will need to 3D print the lamp and put a smart light inside:
- The OpenSCAD source files are in [`3d_models/`](3d_models/), or grab the ready-to-print model on [MakerWorld](https://makerworld.com/en/models/2920312-tower-of-jesus-lamp-sagrada-familia-inauguration#profileId-3267552).
- For the light, you can use kits like the [Bambu Lab 3D lamp kit](https://us.store.bambulab.com/products/led-lamp-kit-001?srsltid=AfmBOorEoRnWnHHTM9JxJwTG3GoRJZFGucuVh8DdPzKqL6Q-1hSD6BMr) that come with a USB LED base — just print the shade and drop it on top.
