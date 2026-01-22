# Golf Range App - Schema Tecnico

## 🏗️ Architettura dell'App

```
┌─────────────────────────────────────────────────────────────┐
│                    GARMIN CONNECT                           │
│              (Cloud Sync - Attività Salvate)               │
└─────────────────────────────────────────────────────────────┘
                          ↑
                    Sync File .FIT
                          ↓
┌─────────────────────────────────────────────────────────────┐
│            VIVOACTIVE 3 (Dispositivo)                       │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  GOLF RANGE APP (GolfRangeApp)                       │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────┐    │  │
│  │  │  ACTIVITY RECORDING SESSION                 │    │  │
│  │  │  - Sport Type: GOLF                        │    │  │
│  │  │  - Start/Stop: Manuale (pulsante)          │    │  │
│  │  │  - Save: Automatico                        │    │  │
│  │  └─────────────────────────────────────────────┘    │  │
│  │                       ↑                              │  │
│  │                       │ Controlla                    │  │
│  │                       │                              │  │
│  │  ┌─────────────────────────────────────────────┐    │  │
│  │  │  DELEGATE (GolfRangeDelegate)               │    │  │
│  │  │  - Logica rilevamento swing                 │    │  │
│  │  │  - Gestione input pulsanti                  │    │  │
│  │  │  - Contatore swing                          │    │  │
│  │  │ - Feedback vibrazione                       │    │  │
│  │  └─────────────────────────────────────────────┘    │  │
│  │           ↑                                ↓         │  │
│  │           │ Dati Sensore                 Display    │  │
│  │           │                              Update     │  │
│  │  ┌────────┴─────────────────────────────┬──────┐    │  │
│  │  │  SENSORE (ACCELEROMETRO)      │  VIEW                  │  │
│  │  │  - 25Hz Sampling              │ (GolfRangeView)        │  │
│  │  │  - Misura Accelerazione       │                        │  │
│  │  │  - Output: Magnitude Vettore  │  Mostra:              │  │
│  │  │                                │  - Titolo              │  │
│  │  │  Formula:                      │  - Stato Recording    │  │
│  │  │  M = √(X² + Y² + Z²)         │  - Contatore Swing    │  │
│  │  │                                │  - Istruzioni         │  │
│  │  └──────────────────────────────┴──────────┘    │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────┐    │  │
│  │  │  HARDWARE FEEDBACK                          │    │  │
│  │  │  - Vibrazione singola: Swing rilevato     │    │  │
│  │  │  - Vibrazione doppia: Inizio              │    │  │
│  │  │  - Vibrazione tripla: Fine                │    │  │
│  │  └─────────────────────────────────────────────┘    │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────┐    │  │
│  │  │  INPUT (Pulsante Fisico)                    │    │  │
│  │  │  - START/ENTER: Avvia/Ferma sessione      │    │  │
│  │  │  - ESC: Torna indietro                     │    │  │
│  │  │  - TOUCH: Per UI avanzate                  │    │  │
│  │  └─────────────────────────────────────────────┘    │  │
│  │                                                       │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  MEMORIA LOCALE                                            │
│  - swingCount (intero)                                     │
│  - isRecording (booleano)                                  │
│  - lastSwingTime (timestamp)                              │
│  - Costanti: SWING_THRESHOLD, MIN_TIME_BETWEEN_SWINGS    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 📊 Flusso di Dati

```
INIZIO SESSIONE
    │
    ├─→ Pulsante START pressato
    │
    ├─→ GolfRangeDelegate.onKey() viene chiamato
    │
    ├─→ startRecording()
    │   ├─→ Crea sessione ActivityRecording
    │   ├─→ session.start()
    │   ├─→ isRecording = true
    │   ├─→ swingCount = 0
    │   └─→ Feedback vibrazione (doppia)
    │
    ├─→ Schermo aggiorna: "● RECORDING"
    │
    └─→ Attende input sensore


REGISTRAZIONE ATTIVA (Loop)
    │
    ├─→ Accelerometro raccoglie dati ogni 40ms (25Hz)
    │
    ├─→ GolfRangeDelegate.onSensor() viene chiamato
    │
    ├─→ Calcola magnitude = √(X² + Y² + Z²)
    │
    ├─→ Controlla SE magnitude > SWING_THRESHOLD
    │
    ├─→ Controlla SE (now - lastSwingTime) > MIN_TIME_BETWEEN_SWINGS
    │
    ├─→ SE entrambe condizioni TRUE:
    │   ├─→ swingCount++
    │   ├─→ lastSwingTime = now
    │   ├─→ Feedback vibrazione (singola)
    │   ├─→ System.println() log
    │   └─→ WatchUi.requestUpdate()
    │
    └─→ Ripete finché isRecording = true


FINE SESSIONE
    │
    ├─→ Pulsante START pressato di nuovo
    │
    ├─→ GolfRangeDelegate.onKey() viene chiamato
    │
    ├─→ stopRecording()
    │   ├─→ session.stop()
    │   ├─→ session.save() ← Salva attività
    │   ├─→ isRecording = false
    │   ├─→ Feedback vibrazione (tripla)
    │   └─→ System.println() log con conteggio totale
    │
    ├─→ Schermo aggiorna: "STOPPED"
    │
    └─→ Attende comando successivo


SINCRONIZZAZIONE (Automatica)
    │
    ├─→ Vivoactive 3 sincronizza con Garmin Connect
    │   (quando connesso via Bluetooth)
    │
    ├─→ File .FIT viene caricato
    │
    ├─→ Attività appare in "Le Mie Attività" → Golf Range
    │
    └─→ Include: Durata, Calorie, HR, Metadati
```

## 🔢 Logica di Rilevamento Swing

```
ALGORITMO RILEVAMENTO SWING:

1. LEGGI DATI ACCELEROMETRO
   └─ X, Y, Z accelerazioni (m/s²)

2. CALCOLA MAGNITUDO VETTORE
   └─ M = √(X² + Y² + Z²)
      Rappresenta l'intensità totale del movimento

3. CONFRONTA CON SOGLIA
   ┌─ SE M ≤ SWING_THRESHOLD (2500)
   │  └─ Scarta (movimento troppo debole)
   │
   └─ SE M > SWING_THRESHOLD (2500)
      └─ Potenziale swing, continua a passo 4

4. VERIFICA DEBOUNCE
   ┌─ SE (now - lastSwingTime) ≤ 1500ms
   │  └─ Scarta (movimento di ritorno dello swing precedente)
   │
   └─ SE (now - lastSwingTime) > 1500ms
      └─ È uno swing nuovo, continua a passo 5

5. REGISTRA SWING
   ├─ swingCount++
   ├─ lastSwingTime = now
   ├─ Vibra
   ├─ Log
   └─ Update schermo

PSEUDOCODICE:
─────────────────────────────────────────────────────────

function onSensor(data):
    IF NOT isRecording:
        return
    
    mag = sqrt(data.x² + data.y² + data.z²)
    now = getTimer()
    
    IF mag > SWING_THRESHOLD AND (now - lastSwingTime) > MIN_WAIT:
        swingCount++
        lastSwingTime = now
        vibrate()
        updateUI()
```

## 🎛️ Costanti Configurabili

```monkeyc
const SWING_THRESHOLD = 2500
    └─ Unità: accelerazione relativa (Gs approssimativo)
    └─ Range suggerito: 1500-3500
    └─ Effetto: ↑ Valore = ↓ Sensibilità

const MIN_TIME_BETWEEN_SWINGS = 1500
    └─ Unità: millisecondi (ms)
    └─ Range suggerito: 1000-2000
    └─ Effetto: ↑ Valore = previene doppi conteggi
```

## 📱 Interfaccia Utente (Layout)

```
┌─────────────────────────────────┐
│     GOLF RANGE                  │  Riga 1-10 px
├─────────────────────────────────┤  Riga 30 px (separatore)
│  ● RECORDING / STOPPED          │  Riga 40-50 px
│                                 │
│                                 │
│            0                    │  Riga 100-150 px (contatore grande)
│          SWINGS                 │  Riga 170-190 px
│                                 │
│                                 │
├─────────────────────────────────┤  Riga 195 px (separatore)
│  Press START to Begin/Stop      │  Riga 200-210 px
│  v1.0.0                         │  Riga 210 px (versione)
└─────────────────────────────────┘

Colori:
- Background: Nero (COLOR_BLACK)
- Titolo: Bianco (COLOR_WHITE)
- Testo: Bianco (COLOR_WHITE)
- Stato RECORDING: Verde (COLOR_GREEN)
- Stato STOPPED: Rosso (COLOR_RED)
- Contatore: Font molto grande (FONT_NUMBER_HOT)
```

## 📋 Sequenza File Build

```
1. source/GolfRangeApp.mc
   └─ Compila per primo (entry point)

2. source/GolfRangeDelegate.mc
   └─ Compila dopo (usato da GolfRangeApp)

3. source/GolfRangeView.mc
   └─ Compila dopo (usato da GolfRangeApp)

4. resources/strings.xml
   └─ Incorporato nel binario

5. manifest.xml
   └─ Fornisce metadati

OUTPUT: bin/GolfRange.prg (singolo file compilato)
```

## 🔐 Permessi Richiesti

```xml
manifest.xml:

<iq:permission id="Sensor" />
    └─ Permette accesso all'accelerometro

<iq:permission id="ActivityRecording" />
    └─ Permette creazione/salvataggio attività
```

## ⚡ Performance & Risorse

```
CPU Usage:
- Idle: < 1%
- Recording: ~5-10% (accelerometro + UI update)

Memory:
- Base App: ~50 KB
- Runtime: ~100-150 KB

Battery:
- Accelerometro 25Hz: 1-2% per ora
- ActivityRecording: 2-3% per ora
- TOTALE: 3-5% per ora di utilizzo

Schermo:
- Res: 240x240 px (Vivoactive 3)
- Refresh: ~30 FPS (su update)
```

## 🔄 Stato Variabili Principali

```
session (ActivityRecording.Session)
    └─ null quando non registra
    └─ Oggetto sessione quando registra

swingCount (Integer)
    └─ 0 all'inizio di ogni sessione
    └─ Incrementa con ogni swing rilevato

isRecording (Boolean)
    └─ false = app in standby
    └─ true = registrazione attiva

lastSwingTime (Integer - timestamp)
    └─ Ultimo tempo in cui è stato rilevato uno swing
    └─ Usato per il debounce
    └─ Inizializzato a 0
```

## 🔧 Come Estendere l'App

### Aggiungere Contatore Distanza Stimata
```monkeyc
// In onSensor:
var estimatedDistance = (swingCount * 150); // Assume 150m per swing
```

### Aggiungere Cronometro
```monkeyc
var sessionStartTime = System.getTimer();
// In view:
var elapsedTime = (System.getTimer() - sessionStartTime) / 1000; // secondi
```

### Aggiungere Storico Sessioni
```monkeyc
var sessionHistory = []; // Array di sessioni precedenti
// Salva swingCount quando finisce la sessione
```

### Aggiungere Statistiche
```monkeyc
// Velocità media swing
var swingsPerMinute = (swingCount / (duration / 60000));
```

## 🧪 Test Verifica

```
☐ App compila senza errori
☐ App installa sul Vivoactive 3
☐ Pulsante START avvia registrazione
☐ Lo schermo mostra "● RECORDING" in verde
☐ Accelerometro registra dati
☐ Swing viene rilevato e vibra
☐ Contatore incrementa accuratamente
☐ Pulsante START ferma registrazione
☐ Sessione appare in Garmin Connect
☐ Conteggio è accurato (±1 swing)
```

---

Fine della documentazione tecnica.
Per domande specifiche, consulta i file .md appropriati.
```

