# Golf Range App - Guida al Troubleshooting

## 🔴 Problemi di Build

### Errore: "GARMIN_HOME not found"

**Problema:**
```
ERROR: Cannot find the Connect IQ SDK
GARMIN_HOME environment variable not set
```

**Soluzione:**

**Windows (PowerShell):**
```powershell
# Imposta la variabile
[Environment]::SetEnvironmentVariable("GARMIN_HOME", "C:\garmin\connect-iq-sdk", "User")

# Verifica che sia impostata
[Environment]::GetEnvironmentVariable("GARMIN_HOME", "User")

# Riavvia PowerShell per applicare le modifiche
```

**Windows (Command Prompt):**
```cmd
setx GARMIN_HOME "C:\garmin\connect-iq-sdk"
REM Riavvia il Command Prompt
```

**macOS/Linux:**
```bash
export GARMIN_HOME=/opt/garmin/connect-iq-sdk
# Aggiungi al ~/.bashrc o ~/.zshrc per renderlo permanente
echo 'export GARMIN_HOME=/opt/garmin/connect-iq-sdk' >> ~/.bashrc
source ~/.bashrc
```

### Errore: "Cannot find monkeyc compiler"

**Problema:**
```
'monkeyc' is not recognized as an internal or external command
```

**Soluzione:**

1. Verifica che l'SDK sia installato correttamente
2. Naviga alla directory bin dell'SDK:
   - Windows: `C:\garmin\connect-iq-sdk\bin\`
   - macOS: `/opt/garmin/connect-iq-sdk/bin/`
3. Aggiungi questo percorso al PATH:

**Windows:**
```powershell
[Environment]::SetEnvironmentVariable("PATH", "C:\garmin\connect-iq-sdk\bin;$env:PATH", "User")
```

### Errore di Sintassi durante Compilazione

**Problema:**
```
Error: Expected '(' at line 45, column 12
```

**Soluzione:**

1. Apri il file indicato nell'errore (es. GolfRangeDelegate.mc linea 45)
2. Controlla la sintassi Monkey C:
   - Tutte le funzioni devono avere le parentesi: `function onKey(keyEvent) { }`
   - Le variabili globali vanno dichiarat fuori dalle funzioni
   - Controlla le parentesi graffe `{ }` e tonde `( )`
3. Consulta il manuale Monkey C su:
   https://developer.garmin.com/connect-iq/monkey-c/

### Errore: "Permission Denied" su build.sh

**Problema:**
```
bash: ./build.sh: Permission denied
```

**Soluzione:**

```bash
chmod +x build.sh
./build.sh
```

---

## 🟡 Problemi di Installazione

### L'App non Appare su Vivoactive 3

**Possibili Cause:**

1. **File non copiato correttamente**
   - Riavvia il dispositivo
   - Riprova a copiare il file .prg

2. **Path sbagliato**
   - Windows: Verifica che sia in:
     ```
     C:\Users\<YourUsername>\AppData\Garmin\ConnectIQApps\Apps\vivoactive3\
     ```
   - macOS: Verifica che sia in:
     ```
     ~/Library/Garmin/ConnectIQApps/Apps/vivoactive3/
     ```

3. **Dispositivo non sincronizzato**
   - Connetti il Vivoactive 3 via USB
   - Apri Garmin Connect
   - Sincronizza manualmente

### Errore durante Installazione sul Simulator

**Problema:**
```
Failed to install application
```

**Soluzione:**

1. Chiudi il Simulator
2. Elimina la cartella cache:
   - Windows: `C:\Users\<Username>\AppData\Local\Garmin`
   - macOS: `~/Library/Caches/Garmin`
3. Riapri il Simulator
4. Riprova l'installazione

---

## 🔵 Problemi di Runtime / Comportamento

### L'App Non Conta Alcuno Swing

**Cause Possibili:**

1. **La registrazione non è avviata**
   - Verifica che lo schermo mostri "● RECORDING" in verde
   - Se vedi "STOPPED" in rosso, premi START

2. **L'accelerometro non è abilitato**
   - Verifica che manifest.xml contenga:
     ```xml
     <iq:uses-permission id="Sensor" />
     ```

3. **La soglia è troppo alta**
   - Riduci `SWING_THRESHOLD` a 1500-2000
   - Ricompila e reinstalla

4. **Il dispositivo non ha sensore accelerometro**
   - Il Vivoactive 3 ha l'accelerometro ✓
   - Verifica compatibilità con l'app

**Debug:**

```monkeyc
// Aggiungi questo nel metodo onSensor per debuggare:
System.println("Magnitude: " + magnitude + ", Threshold: " + SWING_THRESHOLD);
```

Poi esegui il log nel Simulator.

### L'App Conta Troppi Swing (Falsi Positivi)

**Cause Possibili:**

1. **Soglia troppo bassa**
   - Aumenta `SWING_THRESHOLD` a 2800-3200
   - Ricompila e reinstalla

2. **Movimenti casuali del braccio**
   - Stai camminando mentre registri?
   - Tieni il braccio fermo tra uno swing e l'altro

3. **MIN_TIME_BETWEEN_SWINGS troppo bassa**
   - Aumenta a 2000 millisecondi
   - Questo previene il conteggio doppio del movimento di ritorno

**Test per verificare:**
```
Fai 1 swing = app conta 2?
→ Aumenta MIN_TIME_BETWEEN_SWINGS
```

### L'App Conta Troppo Pochi Swing (Falsi Negativi)

**Cause Possibili:**

1. **Soglia troppo alta**
   - Riduci `SWING_THRESHOLD` a 2000-2300
   - Ricompila e reinstalla

2. **Swing deboli non rilevati**
   - Gli swing leggeri potrebbero non generare abbastanza accelerazione
   - Prova swing più veloci

3. **MIN_TIME_BETWEEN_SWINGS troppo alta**
   - Riduci a 1000-1200 millisecondi
   - Questo permette di contare swing veloci consecutivi

**Test per verificare:**
```
Fai 10 swing veloci = app conta meno di 10?
→ Riduci MIN_TIME_BETWEEN_SWINGS
```

### L'App Vibra ma Non Registra

**Possibili Cause:**

1. **ActivityRecording non disponibile**
   - Verifica che manifest.xml contenga:
     ```xml
     <iq:uses-permission id="ActivityRecording" />
     ```

2. **Permessi insufficienti**
   - Reinstalla l'app
   - Riavvia il Vivoactive 3

3. **Batteria del dispositivo scarica**
   - Carica il Vivoactive 3 completamente
   - La registrazione attività usa molta batteria

### L'App Si Blocca o Congela

**Cosa Fare:**

1. **Riavvia il Dispositivo**
   ```
   Tieni premuto il pulsante posteriore per 10 secondi
   Rilascia e aspetta il riavvio
   ```

2. **Forza la Chiusura dell'App**
   ```
   Swipe up dal basso dello schermo (menu recenti)
   Scorri verso sinistra sull'app Golf Range
   Tocca il cestino (delete)
   ```

3. **Reinstalla l'App**
   - Elimina il file .prg
   - Ricompila con `build.bat`
   - Reinstalla

4. **Reset Factory Vivoactive 3**
   ```
   Impostazioni → Sistema → Reset → Ripristina Impostazioni di Fabbrica
   ```

---

## 🟢 Problemi di Sincronizzazione

### La Sessione Non Appare in Garmin Connect

**Causa:** La sincronizzazione è ritardata o il dispositivo non è connesso

**Soluzione:**

1. Connetti il Vivoactive 3 via Bluetooth a Garmin Connect
2. Apri l'app Garmin Connect
3. Seleziona il dispositivo
4. Fai "Sincronizza" manualmente
5. Attendi 5-10 minuti

Se non appare ancora:

1. Verifica che la sessione sia stata salvata (premi START per arrestare)
2. Controlla che Garmin Connect sia connessa a internet
3. Verifica le impostazioni di privacy in Garmin Connect

### La Sessione Non Salva il Numero di Swing

**Causa:** La struttura dati .FIT non include swing count

**Nota Importante:**
Al momento, l'app salva solo il numero di swing **sull'app stessa**. Per visualizzare il conteggio in Garmin Connect, dovresti:

1. Aggiungere un campo FIT personalizzato (avanzato)
2. Oppure leggere i log dell'app sul dispositivo

Per ora, il conteggio è visibile:
- ✓ Sullo schermo del Vivoactive 3
- ✓ Nel log dell'app
- ✓ Nei dati salvati localmente

---

## 💡 Consigli di Troubleshooting Generale

### Prima di Contattare Supporto

1. **Chiedi a te stesso:**
   - Ho riavviato il dispositivo?
   - Ho riavviato il PC/Mac?
   - Ho ricompilato l'app?
   - Ho reinstallato l'app?

2. **Verifica le Basi:**
   - GARMIN_HOME è impostato?
   - L'SDK è installato?
   - Il Vivoactive 3 è carico?
   - Il file .prg è stato generato?

3. **Copia il Messaggio di Errore:**
   - Prendi lo screenshot dell'errore
   - Copia il testo dal terminale
   - Nota l'ora e il numero di linea

### Abilitare Debug Dettagliato

Nel file `GolfRangeDelegate.mc`, aggiungi più log:

```monkeyc
function onSensor(sensorData) {
    System.println("onSensor chiamato, isRecording: " + isRecording);
    
    if (!isRecording) { return; }

    var acc = sensorData.accelerometerData;
    if (acc != null) {
        System.println("Accel X: " + acc.x[0] + ", Y: " + acc.y[0] + ", Z: " + acc.z[0]);
        // ... resto del codice
    }
}
```

Poi esegui nel Simulator e leggi la console.

### Se Nulla Funziona

1. Crea una cartella di backup del progetto
2. Scarica di nuovo l'SDK Garmin Connect IQ
3. Crea un nuovo progetto da zero
4. Copia i file `source/` uno alla volta e testa

---

## 📞 Risorse di Supporto

### Documentazione Ufficiale
- [Garmin Connect IQ Developer](https://developer.garmin.com/connect-iq/)
- [Monkey C Language Reference](https://developer.garmin.com/connect-iq/monkey-c/)
- [Sensor API Documentation](https://developer.garmin.com/connect-iq/api-docs/Toybox/Sensor.html)

### Community
- [Garmin Forums](https://forums.garmin.com/developers)
- [GitHub Issues](https://github.com/search?q=garmin+connect+iq)
- [Stack Overflow Tag: garmin-connect-iq](https://stackoverflow.com/questions/tagged/garmin-connect-iq)

### Contatti
Per problemi specifici, consulta:
- File CALIBRATION.md per problemi di rilevamento swing
- File INSTALLATION.md per problemi di setup
- File README.md per documentazione generale

---

## ✅ Checklist Diagnostica Rapida

```
☐ GARMIN_HOME è impostato?          → setx GARMIN_HOME "C:\path\to\sdk"
☐ SDK è installato correttamente?   → Controlla C:\garmin\connect-iq-sdk
☐ Vivoactive 3 è carico?            → Carica al 100%
☐ L'app compila senza errori?       → Esegui build.bat
☐ Il file .prg è stato creato?      → Controlla bin\GolfRange.prg
☐ L'app è installata sul dispositivo? → Copia il file .prg
☐ La registrazione è avviata?       → Vedi "● RECORDING" in verde?
☐ I sensori sono abilitati?         → Controlla manifest.xml
☐ Il dispositivo ha l'accelerometro? → Vivoactive 3 sì ✓
☐ Hai testato nel Simulator prima?  → Esegui nel Simulator di Connect IQ
```

Se ancora non funziona, controlla questo file dalla riga corrispondente al tuo problema sopra.

---

Buon debugging! ⛳🔧
