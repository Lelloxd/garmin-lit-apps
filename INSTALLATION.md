# Guida di Installazione - Golf Range App

## Prerequisiti

Prima di iniziare, assicurati di avere:

1. **Garmin Vivoactive 3** (o dispositivo compatibile)
2. **Garmin Connect IQ SDK** installato
3. **MonkeyC Compiler** (incluso nell'SDK)
4. **Garmin Connect** app installata sul tuo smartphone

## Step 1: Installazione del Garmin Connect IQ SDK

### Su Windows:
1. Scarica il SDK da: https://developer.garmin.com/connect-iq/download/
2. Esegui l'installer e segui le istruzioni
3. Nota il percorso di installazione (es. `C:\garmin\connect-iq-sdk`)

### Impostare la variabile di ambiente GARMIN_HOME:

**Windows (PowerShell):**
```powershell
[Environment]::SetEnvironmentVariable("GARMIN_HOME", "C:\garmin\connect-iq-sdk", "User")
# Riavvia PowerShell
```

**Windows (Command Prompt):**
```cmd
setx GARMIN_HOME "C:\garmin\connect-iq-sdk"
REM Riavvia il Command Prompt
```

**macOS/Linux:**
```bash
export GARMIN_HOME=/path/to/garmin-connect-iq-sdk
# Aggiungi al tuo ~/.bashrc o ~/.zshrc per renderlo permanente
```

## Step 2: Compilare l'App

### Su Windows:
```batch
# Naviga al directory del progetto
cd C:\Users\fraio\Documents\garmingolf

# Esegui lo script di build
build.bat
```

### Su macOS/Linux:
```bash
cd ~/Documents/garmingolf
chmod +x build.sh
./build.sh
```

Questo genererà il file `bin/GolfRange.prg`

## Step 3: Installare sul Dispositivo

### Opzione A: Tramite Garmin Connect IQ Simulator

1. Apri il **Connect IQ Simulator** dal tuo SDK
2. Seleziona **Vivoactive 3** come dispositivo target
3. Carica il file `bin/GolfRange.prg`
4. Prova l'app nel simulatore

### Opzione B: Tramite Dispositivo Fisico

1. Connetti il Vivoactive 3 al PC/Mac via USB
2. Usa il Connect IQ Simulator o copia manualmente:
   - Windows: `C:\Users\<YourUsername>\AppData\Garmin\ConnectIQApps\Apps\vivoactive3\`
   - macOS: `~/Library/Garmin/ConnectIQApps/Apps/vivoactive3/`
3. Copia il file `.prg` in quella directory
4. Il dispositivo sincronizzerà automaticamente

### Opzione C: Tramite Developer Connect IQ

Utilizza lo strumento **Developer Connect IQ** incluso nell'SDK per il debugging in tempo reale

## Step 4: Test e Calibrazione

1. Apri l'app **Golf Range** sul Vivoactive 3
2. Premi il pulsante START/ENTER per iniziare
3. Fai alcuni swing di prova per testare il rilevamento
4. Se l'app:
   - **Non rileva gli swing**: Riduci `SWING_THRESHOLD` nel file `source/GolfRangeDelegate.mc` (es. 2000)
   - **Conta troppi swing**: Aumenta `SWING_THRESHOLD` (es. 3000)
5. Ricompila e ripeti finché non trovi il valore perfetto

## Step 5: Uso Reale

Una volta calibrato:

1. Vai al practice range con il Vivoactive 3
2. Indossa il dispositivo al polso normalmente
3. Apri l'app Golf Range
4. Premi START per iniziare la sessione
5. L'app conterà automaticamente i tuoi swing
6. Al termine, premi START di nuovo per fermare
7. La sessione sarà salvata automaticamente in Garmin Connect

## Troubleshooting

### "GARMIN_HOME not found"
- Assicurati di aver impostato la variabile di ambiente GARMIN_HOME
- Riavvia il terminale/PowerShell dopo averla impostata

### Errore durante la compilazione
```
ERROR: Cannot find the Connect IQ SDK
```
- Verifica che il SDK sia correttamente installato
- Controlla che GARMIN_HOME punti al percorso corretto

### L'app non si installa
- Assicurati che il Vivoactive 3 sia connesso via USB
- Prova a riavviare il dispositivo
- Prova a usare il Simulator prima

### Rilevamento swing non accurato
- Regola `SWING_THRESHOLD` e `MIN_TIME_BETWEEN_SWINGS` in `GolfRangeDelegate.mc`
- Test con swing di intensità diversa
- Assicurati di indossare il dispositivo correttamente (vicino al polso)

### L'app si blocca
- Riavvia il Vivoactive 3 (tieni premuto il pulsante posteriore)
- Reinstalla l'app
- Controlla il log con il Simulator per errori

## Struttura File Progetto

```
garmingolf/
├── manifest.xml              # Permessi e metadata app
├── monkey.jungle             # Configurazione build principale
├── build.properties          # Proprietà di build
├── build.bat                 # Script build Windows
├── build.sh                  # Script build macOS/Linux
├── README.md                 # Documentazione generale
├── INSTALLATION.md           # Questo file
├── source/
│   ├── GolfRangeApp.mc      # Main application class
│   ├── GolfRangeDelegate.mc # Sensor logic & activity recording
│   └── GolfRangeView.mc     # UI display
├── resources/
│   └── strings.xml          # App strings & localization
└── bin/                      # Output directory (creato dopo build)
    └── GolfRange.prg         # Compiled app
```

## Configurazione Avanzata

### Modificare il Threshold di Sensibilità

Apri `source/GolfRangeDelegate.mc` e modifica:

```monkeyc
const SWING_THRESHOLD = 2500; // Valore predefinito

// Valori consigliati:
// 1500 - Molto sensibile (conta quasi tutto)
// 2000 - Sensibile
// 2500 - Normale (consigliato)
// 3000 - Meno sensibile
// 3500 - Poco sensibile (solo colpi forti)
```

### Modificare il Debounce

```monkeyc
const MIN_TIME_BETWEEN_SWINGS = 1500; // millisecondi

// Abbassa se conti molti swing singoli come multipli
// Alza se gli swing rapidi non vengono tutti contati
```

## Risorse Utili

- [Garmin Connect IQ Developer Portal](https://developer.garmin.com/connect-iq/)
- [Garmin Connect IQ API Reference](https://developer.garmin.com/connect-iq/api-docs/)
- [MonkeyC Documentation](https://developer.garmin.com/connect-iq/monkey-c/)
- [Garmin Sensor Documentation](https://developer.garmin.com/connect-iq/api-docs/Toybox/Sensor.html)

## Support

Per domande o problemi:
1. Controlla il log nel Simulator
2. Rivedi la sezione Troubleshooting
3. Consulta la documentazione ufficiale di Garmin

Buon allenamento al range! ⛳
