═══════════════════════════════════════════════════════════════════════════════
                       GOLF RANGE - UI MOCKUP VISUALE
═══════════════════════════════════════════════════════════════════════════════

SCHERMO VIVOACTIVE 3: 240×240 PIXEL
RISOLUZIONE: AMOLED
ORIENTAMENTO: Verticale

═══════════════════════════════════════════════════════════════════════════════

SCHERMATA 1: APP NON AVVIATA (STOPPED)

┌────────────────────────────────────────┐
│                                        │
│          GOLF RANGE                    │
│                                        │
├────────────────────────────────────────┤
│                                        │
│          STOPPED                       │ ← In ROSSO (COLOR_RED)
│          (Rosso)                       │
│                                        │
│                                        │
│                0                       │ ← Numeri grandi
│                                        │
│              SWINGS                    │
│                                        │
│                                        │
├────────────────────────────────────────┤
│                                        │
│     Press START to Begin               │
│                                        │
│              v1.0.0                    │
│                                        │
└────────────────────────────────────────┘

COLORI:
- Background: Nero (COLOR_BLACK)
- Titolo "GOLF RANGE": Bianco (COLOR_WHITE)
- Stato "STOPPED": Rosso (COLOR_RED)
- Numero "0": Bianco (COLOR_WHITE)
- Font: FONT_XTINY, FONT_NUMBER_HOT

═══════════════════════════════════════════════════════════════════════════════

SCHERMATA 2: REGISTRAZIONE ATTIVA (RECORDING)

┌────────────────────────────────────────┐
│                                        │
│          GOLF RANGE                    │
│                                        │
├────────────────────────────────────────┤
│                                        │
│          ● RECORDING                   │ ← In VERDE (COLOR_GREEN)
│          (Verde con puntino)           │
│                                        │
│                                        │
│                5                       │ ← Aumenta con ogni swing!
│                                        │
│              SWINGS                    │
│                                        │
│                                        │
├────────────────────────────────────────┤
│                                        │
│     Press START to Stop                │
│                                        │
│              v1.0.0                    │
│                                        │
└────────────────────────────────────────┘

COLORI:
- Background: Nero (COLOR_BLACK)
- Titolo "GOLF RANGE": Bianco (COLOR_WHITE)
- Stato "● RECORDING": Verde (COLOR_GREEN)
- Numero "5": Bianco (COLOR_WHITE)
- Font: FONT_XTINY, FONT_NUMBER_HOT

NOTA: Il numero incrementa ogni volta che viene rilevato uno swing!

═══════════════════════════════════════════════════════════════════════════════

SCHERMATA 3: DOPO MOLTI SWING

┌────────────────────────────────────────┐
│                                        │
│          GOLF RANGE                    │
│                                        │
├────────────────────────────────────────┤
│                                        │
│          ● RECORDING                   │
│                                        │
│                                        │
│               42                       │ ← Numero grande e leggibile
│                                        │
│              SWINGS                    │
│                                        │
│                                        │
├────────────────────────────────────────┤
│                                        │
│     Press START to Stop                │
│                                        │
│              v1.0.0                    │
│                                        │
└────────────────────────────────────────┘

IL NUMERO SI AGGIORNA IN TEMPO REALE!

═══════════════════════════════════════════════════════════════════════════════

INTERAZIONE UTENTE

┌─────────────────────────────────────────────────────────┐
│ AZIONE                    │ RISULTATO                   │
├───────────────────────────┼─────────────────────────────┤
│ Premi START (da STOPPED)  │ • Schermo cambia a RECORD. │
│                           │ • Inizia vibrazione (×2)   │
│                           │ • Accelerometro attivo     │
│                           │                             │
│ Fai uno swing            │ • Vibrazione singola (×1)  │
│ (durante RECORDING)       │ • Contatore incrementa     │
│                           │ • Sound/haptic feedback    │
│                           │                             │
│ Premi START (da REC.)    │ • Schermo cambia a STOPPED │
│                           │ • Vibrazione (×3)          │
│                           │ • Sessione salva su device │
│                           │ • Dati pronti per sincro   │
│                           │                             │
│ Premi ESC                │ • Torna alla home screen   │
│                           │ • Sessione continua se     │
│                           │   era attiva               │
└───────────────────────────┴─────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════════

SEQUENCE DIAGRAM: Cosa Succede Quando Avvii l'App

        USER              DEVICE           APP                  GARMIN
         │                 │               │                     │
         ├─ Avvia App ─────→│               │                     │
         │                 ├─ Inizializza ─→│                     │
         │                 │               ├─ Carica Sensori     │
         │                 │               │ (25Hz Accelerometro)│
         │                 │               │                     │
         ├─ Premi START ───→│               │                     │
         │                 ├─ onKey() ─────→│                     │
         │                 │               ├─ startRecording()  │
         │                 │               ├─ createSession() ──→│ (Golf)
         │                 │               ├─ vibrate() (×2)    │
         │                 ├─ UI Update ───→│                     │
         │                 │               │ "● RECORDING"      │
         │                 │               │                     │
         ├─ Fai 1 Swing ───→│               │                     │
         │                 ├─ onSensor() ──→│                     │
         │                 │               ├─ Calcola Magnitude │
         │                 │               ├─ Confronta Soglia  │
         │                 │               ├─ Conta Swing (1)   │
         │                 │               ├─ vibrate() (×1)    │
         │                 ├─ UI Update ───→│                     │
         │                 │               │ Display "1"        │
         │                 │               │                     │
         ├─ Premi START ───→│               │                     │
         │                 ├─ onKey() ─────→│                     │
         │                 │               ├─ stopRecording()   │
         │                 │               ├─ session.save() ──→│ (Save)
         │                 │               ├─ vibrate() (×3)    │
         │                 ├─ UI Update ───→│                     │
         │                 │               │ "STOPPED"          │
         │                 │               │                     │
         │                 │ [~10 minutes] │                     │
         │                 │               │   ├─ Sync Data ────→│
         │                 │               │   │ (via BT)       │
         │                 │               │   │                 │
         │                 │               │ ← ─ Ack ────────────│
         │                 │               │                     │
         ├─ Apri Garmin ───────────────────────────────────────→│
         │                 │               │     ├─ Show Activity
         │                 │               │     ├─ "Golf Range"
         │                 │               │     └─ 1 Swing
         │                 │               │                     │

═══════════════════════════════════════════════════════════════════════════════

FLUSSO DATI SENSORIALE

ACCELEROMETRO (Vivoactive 3)
    │
    ├─ Misura ogni 40ms (25Hz)
    │
    ├─ Output per campione:
    │  ├─ X (accelerazione asse X)
    │  ├─ Y (accelerazione asse Y)
    │  └─ Z (accelerazione asse Z)
    │
    ├─ GolfRangeDelegate.onSensor()
    │  ├─ IF NOT recording
    │  │  └─ Scarta dati
    │  │
    │  └─ IF recording
    │     ├─ M = √(X² + Y² + Z²)  ← Magnitudo
    │     ├─ IF M > 2500           ← Soglia
    │     │  └─ IF (now-last) > 1500ms  ← Debounce
    │     │     ├─ swingCount++
    │     │     ├─ vibrate()
    │     │     └─ updateUI()
    │     │
    │     └─ Ripeti per ogni campione
    │
    └─ GolfRangeView.onUpdate()
       └─ Disegna contatore aggiornato

═══════════════════════════════════════════════════════════════════════════════

FEEDBACK TATTILE (Vibration)

EVENTO                      FEEDBACK VIBRAZIONE
─────────────────────────────────────────────────────────
Inizio Registrazione        ● ● (due brevi vibrazioni)
                            Durata: 30ms + 50ms pausa + 30ms

Swing Rilevato             ● (una breve vibrazione)
                            Durata: 20ms (leggera)

Fine Registrazione         ● ● ● (tre brevi vibrazioni)
                            Durata: 50ms + 50ms pausa + 50ms + 50ms pausa + 50ms

═══════════════════════════════════════════════════════════════════════════════

TIMELINE SESSIONE TIPICA (al Practice Range)

MINUTO  EVENTO                          SCREEN                SWING_COUNT
─────────────────────────────────────────────────────────────────────────
0:00    Apri app                        STOPPED               0
        "Press START to Begin"

0:05    Premi START                     ● RECORDING           0
        (vibrazione doppia)             "Press START to Stop"

0:10    Primo swing                     ● RECORDING           1
        (vibrazione singola)            "1 SWINGS"

0:15    Secondo swing                   ● RECORDING           2

0:20    Terzo swing                     ● RECORDING           3

0:25    Quarto swing                    ● RECORDING           4

0:30    Movimento braccio (no swing)    ● RECORDING           4
        (nessuna vibrazione)            (nessun cambio)

1:15    10° swing                       ● RECORDING           10
        (vibrazione singola)

2:30    Pausa - riposo                  ● RECORDING           10
        (nessuna attività)              (nessun cambio)

5:00    20° swing                       ● RECORDING           20

10:00   Premi START                     STOPPED               20
        (vibrazione tripla)             "Press START to Begin"
        [SESSIONE SALVATA]

10:05   Sincronizzazione BT             STOPPED               20
        (Automatica con Garmin)         (dati inviati)

10:15   Apri Garmin Connect App         GOLF RANGE            
        "Golf Range"                    20 Swings
        Sincronizzato ✓                 Durata: 10:00 min

═══════════════════════════════════════════════════════════════════════════════

PARAMETRI VISUALI VS CODE

Colors disponibili in Toybox.Graphics:
  COLOR_BLACK        = Nero (Background)
  COLOR_WHITE        = Bianco (Testo principale)
  COLOR_GREEN        = Verde (● RECORDING)
  COLOR_RED          = Rosso (STOPPED)

Font disponibili:
  FONT_XTINY         = Testo piccolo (istruzioni)
  FONT_TINY          = Stato
  FONT_SMALL         = Titolo
  FONT_MEDIUM        = Etichette
  FONT_NUMBER_HOT    = Numeri GRANDI (contatore)

Text Alignment:
  TEXT_JUSTIFY_LEFT
  TEXT_JUSTIFY_CENTER   ← Usato principalmente
  TEXT_JUSTIFY_RIGHT

═══════════════════════════════════════════════════════════════════════════════

LAYOUT POSIZIONI PIXEL (240×240)

┌─────────────────────────────────────┐
│         (0, 0)           (240, 0)   │
│                                     │
│   Y=10  GOLF RANGE                  │
│                                     │
│   Y=30  ═════════════════           │ Separatore
│                                     │
│   Y=50  ● RECORDING / STOPPED       │
│                                     │
│   Y=120 (grande numero)             │ Centro schermo
│         0,  5,  20,  42...          │ (X=120 center)
│                                     │
│   Y=180 SWINGS                      │
│                                     │
│   Y=195 ═════════════════           │ Separatore
│                                     │
│   Y=210 Press START to Begin        │
│   Y=230 v1.0.0                      │
│                                     │
│         (0, 240)        (240, 240)  │
└─────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════════

STATO MEMORIA DURANTE SESSIONE

VARIABILE              TIPO       INIZIO    DURANTE    FINE
─────────────────────────────────────────────────────────────
session                Object     null      Active     null
swingCount             Integer    0         0→∞        ultimo
isRecording            Boolean    false     true       false
lastSwingTime          Integer    0         timestamp  (last)
lastUpdateTime         Integer    0         timestamp  (last)
totalDistance          Integer    0         0          0

═══════════════════════════════════════════════════════════════════════════════

POSSIBILI ERRORI VISIVI

1. "● RECORDING in rosso invece di verde"
   └─ Bug: Colore non impostato correttamente
   └─ Soluzione: Controlla GolfRangeView.mc linea ~60

2. "Contatore non aggiorna"
   └─ Possibile causa: WatchUi.requestUpdate() non chiamato
   └─ Soluzione: Verifica GolfRangeDelegate.mc onSensor()

3. "Font troppo piccolo/grande"
   └─ Soluzione: Modifica FONT_* in GolfRangeView.mc

4. "Numeri non centrati"
   └─ Soluzione: Usa TEXT_JUSTIFY_CENTER

═══════════════════════════════════════════════════════════════════════════════

COMPORTAMENTO NORMALE vs ANOMALO

COMPORTAMENTO                          NORMALE? AZIONE
────────────────────────────────────────────────────────────
Premi START → vibra ×2                 ✓ OK    Nessuna
Faccio swing → vibra ×1                ✓ OK    Nessuna
Premi START → vibra ×3                 ✓ OK    Nessuna
                                       
Premi START → no vibrazione            ✗ BUG   Vedi Troubleshooting
Swing → no vibrazione                  ✗ BUG   Vedi CALIBRATION.md
Contatore non incrementa               ✗ BUG   Vedi Troubleshooting
Testo non leggibile                    ✗ BUG   Modifica font
Schermo nero                           ✗ BUG   Riavvia app/device

═══════════════════════════════════════════════════════════════════════════════

Fine della documentazione UI visuale.
Per ulteriori dettagli tecnici, vedi TECHNICAL.md

