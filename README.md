# Golf Range Swings - Garmin Connect IQ

An application for Garmin devices (Vivoactive 3, Fenix, Forerunner, etc.) that automatically tracks the number of swings during a practice range session.

🌐 **Website & Guide:** [Visit Official Site](https://lelloxd.github.io/garmin-lit-apps/)
📂 **Source Code:** [GitHub Repository](https://github.com/Lelloxd/garmin-lit-apps)

## Features

- ✅ **Automatic Swing Detection** via accelerometer
- ✅ **Activity Recording** saved to Garmin Connect (Golf)
- ✅ **Touch-friendly & Button Interface**
- ✅ **Haptic Feedback** for every detected swing
- ✅ **Real-time Counter**

## How to Use

1. Launch the "Golf Range Swings" app on your device.
2. Press the **START** button to begin recording.
3. The app will automatically count swings when acceleration is detected.
4. Press **START** again to stop the session.
5. The session will be automatically saved and synced with Garmin Connect.

## Calibration

If the app misses swings or counts too many, you can calibrate the sensitivity threshold:

1. Open the file `source/GolfRangeDelegate.mc`.
2. Modify the `SWING_THRESHOLD` constant:
   - **Lower value** (e.g., 2000) = More sensitive (detects lighter swings).
   - **Higher value** (e.g., 3500) = Less sensitive (detects only strong swings).
3. Recompile the app.

## Requirements

- Garmin Device (Vivoactive 3, Venu, Fenix, Forerunner, etc.)
- Garmin Connect IQ SDK
- MonkeyC Compiler

## Project Structure

```
garmingolf/
├── manifest.xml
├── monkey.jungle
├── source/
│   ├── GolfRangeApp.mc
│   ├── GolfRangeDelegate.mc 
│   └── GolfRangeView.mc     
└── resources/
    └── strings.xml          
```
## Technical Details

### Swing Detection
The app monitors the device's internal sensors to detect:
* **Acceleration Magnitude:** Real-time analysis of the 3-axis acceleration vector.
* **Debounce Logic:** A 1.5-second lockout period between detections to eliminate "double-counting" during the follow-through.
* **Adjustable Threshold:** Sensitivity can be tuned via the on-device menu (default: 2000mg).

### Activity Recording
* **Garmin Integration:** Uses `ActivityRecording` to create native `.FIT` files.
* **Auto-Sync:** Seamlessly uploads data to the Garmin Connect cloud.
* **Developer Fields:** Includes custom fields for total swing count and "swings-per-moment" activity charts.

### Haptic Feedback
* **Single Vibration:** Swing successfully detected.
* **Double Vibration:** Recording session started.
* **Triple Vibration:** Session stopped and data saved.

---

## Troubleshooting

**The app is not counting any swings:**
* The sensitivity threshold might be too high. Swipe left to open the menu and reduce the `SWING_THRESHOLD`.
* Ensure you are performing full, high-velocity swings.

**The app is counting too many swings:**
* The threshold might be too low. Increase the `SWING_THRESHOLD`.
* If the app catches the backswing, consider increasing the `MIN_TIME_BETWEEN_SWINGS` in the source code.

**The app is unresponsive:**
* Restart your Vivoactive 3 device.
* Reinstall the app via the Connect IQ Store or Garmin Express.

---

## Development & Compatibility

* **SDK Version:** Optimized for Connect IQ SDK 7.x and 8.x.
* **Resolution:** 240x240 px (Optimized for round displays like Vivoactive 3).
* **Sampling:** 25Hz Accelerometer rate for high accuracy with low battery impact.

## Versioning
* **v1.0.0** - Initial Release: Core swing detection, Golf activity profile, and FIT charts.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Enjoy your practice session at the range!* ⛳

