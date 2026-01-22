# Golf Range App - Garmin Connect IQ

Un'applicazione per Garmin Vivoactive 3 che traccia automaticamente il numero di swing durante una sessione al practice range.

## Caratteristiche

- ✅ **Rilevamento automatico degli swing** tramite accelerometro
- ✅ **Registrazione attività** salvata su Garmin Connect
- ✅ **Interfaccia touch-friendly** per il Vivoactive 3
- ✅ **Feedback aptico** per ogni swing rilevato
- ✅ **Contatore in tempo reale**

## Come Usare

1. Avvia l'app "Golf Range" dal tuo Vivoactive 3
2. Premi il pulsante START per iniziare la registrazione
3. L'app inizierà a contare automaticamente gli swing quando rileva l'accelerazione
4. Premi START di nuovo per terminare la sessione
5. La sessione verrà salvata automaticamente e sincronizzata con Garmin Connect

## Calibrazione

Se l'app non rileva i tuoi swing o ne conta troppi, puoi calibrare la soglia di sensibilità:

1. Apri il file `source/GolfRangeDelegate.mc`
2. Modifica la costante `SWING_THRESHOLD`:
   - **Valore più basso** (es. 2000) = più sensibile (conta anche swing leggeri)
   - **Valore più alto** (es. 3500) = meno sensibile (conta solo swing forti)
3. Ricompila l'app

## Requisiti

- Garmin Vivoactive 3
- Garmin Connect IQ SDK
- MonkeyC Compiler

## Struttura del Progetto

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
