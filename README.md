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
├── manifest.xml              # Configurazione permessi app
├── monkey.jungle             # Configurazione build
├── source/
│   ├── GolfRangeApp.mc      # Entry point dell'applicazione
│   ├── GolfRangeDelegate.mc # Logica rilevamento swing
│   └── GolfRangeView.mc     # Interfaccia utente
└── resources/
    └── strings.xml          # Stringhe e localizzazione
```

## Dettagli Tecnici

### Rilevamento Swing

L'app utilizza l'accelerometro del dispositivo per rilevare:
- La magnitudo del vettore accelerazione durante lo swing
- Un debounce di 1,5 secondi per evitare conteggi duplicati
- Una soglia di sensibilità (modificabile)

### Registrazione Attività

- Salvata come attività "Golf" su Garmin Connect
- Sincronizzata automaticamente con l'app Garmin Connect
- Include durata, calorie (calcolate su battito cardiaco), e metadati

### Feedback Utente

- **Vibrazione singola** = Swing rilevato
- **Vibrazione doppia** = Inizio registrazione
- **Vibrazione tripla** = Fine registrazione

## Troubleshooting

**L'app non conta nessuno swing:**
- La soglia potrebbe essere troppo alta. Riduci `SWING_THRESHOLD`
- Assicurati di fare swing ampi e veloci

**L'app conta troppi swing:**
- La soglia potrebbe essere troppo bassa. Aumenta `SWING_THRESHOLD`
- Potrebbe contare il movimento di ritorno. Aumenta `MIN_TIME_BETWEEN_SWINGS`

**L'app si blocca:**
- Riavvia il dispositivo Vivoactive 3
- Riinstalla l'app

## Versione

- **v1.0.0** - Release iniziale

## Autore

Sviluppato per Garmin Connect IQ

## Note

Per il Vivoactive 3, l'app è ottimizzata per:
- Schermo AMOLED 240x240 px
- Accelerometro a 25Hz
- Pulsante fisico e touchscreen

Goditi il tuo allenamento al range! ⛳
