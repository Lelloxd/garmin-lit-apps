# Golf Range - Guida di Calibrazione

## Cos'è la Calibrazione?

La calibrazione è il processo di regolazione della sensibilità dell'app al rilevamento degli swing. Ogni polso è diverso, ogni swing è diverso, quindi trovare il valore giusto per te è importante.

## Parametri Principali

### SWING_THRESHOLD
Questo è il valore di sensibilità principale. Rappresenta la magnitudo minima dell'accelerazione che l'app considera come uno swing.

**File:** `source/GolfRangeDelegate.mc`

```monkeyc
const SWING_THRESHOLD = 2500; // Modifica questo valore
```

### Valori di Riferimento

| Valore | Sensibilità | Descrizione |
|--------|------------|------------|
| 1500 | Molto Alta | Rileva quasi ogni movimento - potrebbe contare movimenti involontari |
| 2000 | Alta | Rileva swing leggeri ma accuratamente |
| **2500** | **Normale** | **Impostazione predefinita - buon equilibrio** |
| 3000 | Bassa | Rileva solo swing normali, ignora tremori |
| 3500 | Molto Bassa | Rileva solo colpi forti - potrebbero mancare swing deboli |

### MIN_TIME_BETWEEN_SWINGS
Questo evita che il movimento di ritorno o le vibrazioni vengano contate come swing separati.

```monkeyc
const MIN_TIME_BETWEEN_SWINGS = 1500; // Millisecondi
```

**Regole:**
- Se conti uno swing come due, **aumenta** questo valore (1500 → 2000)
- Se swing rapidi consecutivi non vengono contati, **riduci** questo valore (1500 → 1000)

## Procedura di Calibrazione

### Passo 1: Setup Iniziale

1. Verifica che il Vivoactive 3 sia carico
2. Indossalo al polso come faresti normalmente (non troppo stretto, non troppo lasco)
3. Carica l'app Golf Range

### Passo 2: Test Iniziale con Valori Predefiniti

1. Apri l'app e premi START
2. Fai 10 swing **normali** (velocità media)
3. L'app dovrebbe contare 10 swing
4. Se il conteggio è accurato, sei fortunato! Passa a Passo 3
5. Se non è accurato, nota il problema:
   - **Conta troppi** (es. 15 invece di 10) → vai a Passo 3a
   - **Conta troppo pochi** (es. 5 invece di 10) → vai a Passo 3b

### Passo 3a: Conta Troppi Swing (Falsi Positivi)

Aumenta la soglia `SWING_THRESHOLD`:

```monkeyc
// Da:
const SWING_THRESHOLD = 2500;

// A:
const SWING_THRESHOLD = 2800;
```

1. Ricompila: `build.bat`
2. Reinstalla l'app
3. Ripeti Passo 2
4. Se ancora troppi, aumenta ancora (es. 3000, 3200, 3500)
5. Se migliora ma ancora non perfetto, aumenta di meno (2600, 2700)

### Passo 3b: Conta Troppo Pochi Swing (Falsi Negativi)

Riduci la soglia `SWING_THRESHOLD`:

```monkeyc
// Da:
const SWING_THRESHOLD = 2500;

// A:
const SWING_THRESHOLD = 2200;
```

1. Ricompila: `build.bat`
2. Reinstalla l'app
3. Ripeti Passo 2
4. Se ancora troppo pochi, riduci ancora (es. 2000, 1800, 1500)
5. Se migliora ma ancora non perfetto, riduci di meno (2300, 2400)

### Passo 3c: Problema di Debounce (Conta Uno Swing Come Due)

Se fai uno swing singolo e l'app ne conta 2:

```monkeyc
// Aumenta da:
const MIN_TIME_BETWEEN_SWINGS = 1500;

// A:
const MIN_TIME_BETWEEN_SWINGS = 2000;
```

Questo previene che il movimento di ritorno sia contato separatamente.

## Matrice di Calibrazione

Copia questa tabella e compila mentre fai i test:

```
Data: ___________
Tempo: ___________
Swing Fatti: 10
Swing Contati: ___

SWING_THRESHOLD: 2500
MIN_TIME_BETWEEN_SWINGS: 1500

Note: _________________________________
Prossimo Valore da Provare: ____________
```

## Test Avanzati

Una volta che la calibrazione di base funziona, prova questi test:

### Test 1: Swing Leggeri
- Fai 10 swing molto leggeri
- Verifica il conteggio
- Se non ne conta alcuni, il valore è troppo alto

### Test 2: Swing Veloci Consecutivi
- Fai 5 swing il più veloce possibile
- Verifica che li conti tutti come 5, non di più
- Se li conta come 7-10, il MIN_TIME_BETWEEN_SWINGS è troppo basso

### Test 3: Swing Forti
- Fai 10 swing il più forte possibile
- Verifica che li conti tutti
- Normalmente questo non dovrebbe essere un problema

### Test 4: Movimento del Braccio
- Muovi il braccio normalmente (come se camminassi al range)
- L'app non dovrebbe contare movimenti casuali
- Se conta movimenti normali, il SWING_THRESHOLD è troppo basso

## Registro di Calibrazione

Mantieni un file `CALIBRATION_LOG.txt` con i tuoi valori testati:

```
2026-01-22 Test 1:
- SWING_THRESHOLD: 2500
- MIN_TIME_BETWEEN_SWINGS: 1500
- Swing Fatti: 10
- Swing Contati: 12
- Risultato: TROPPI (falsi positivi)
- Azione: Aumenta SWING_THRESHOLD a 2700

2026-01-22 Test 2:
- SWING_THRESHOLD: 2700
- MIN_TIME_BETWEEN_SWINGS: 1500
- Swing Fatti: 10
- Swing Contati: 9
- Risultato: TROPPO POCHI (falsi negativi)
- Azione: Riduci a 2600

...
```

## Fattori che Influenzano il Rilevamento

1. **Polso:** Persone con polsi diversi generano accelerazioni diverse
2. **Posizione indosso:** Troppo stretto/lasco cambia i dati
3. **Angolo dello swing:** Swing verticale vs. orizzontale
4. **Velocità dello swing:** Swing lenti vs. veloci
5. **Fitness:** Una persona più forte genera più Gs
6. **Tipo di mazza:** Legno vs. ferro
7. **Superficie:** Range coperto vs. aperto

## Valori Consigliat per Profili Diversi

### Principiante Leggero
```
SWING_THRESHOLD = 1800
MIN_TIME_BETWEEN_SWINGS = 1200
```

### Dilettante Medio
```
SWING_THRESHOLD = 2500 (Predefinito)
MIN_TIME_BETWEEN_SWINGS = 1500
```

### Golfista Esperto / Swing Forte
```
SWING_THRESHOLD = 3200
MIN_TIME_BETWEEN_SWINGS = 1800
```

### Molto Sensibile (Rileva Quasi Tutto)
```
SWING_THRESHOLD = 1500
MIN_TIME_BETWEEN_SWINGS = 1000
```

## Quando Ricalibrare

- ✓ Quando cambi dispositivo
- ✓ Quando la precisione peggiora nel tempo (batteria bassa?)
- ✓ Se fai swing molto diversi dal solito
- ✓ Dopo aver pulito/riavviato il dispositivo
- ✓ Se aggiorni l'app

## Troubleshooting

### App non conta niente
1. Assicurati che l'accelerometro sia abilitato nel manifest
2. Abbassa SWING_THRESHOLD a 1500
3. Verifica che il dispositivo stia registrando (schermo deve mostrare "● RECORDING")

### Conta swing quando non ce ne sono
1. Abbassa SWING_THRESHOLD (probabilmente troppo basso)
2. Aumenta MIN_TIME_BETWEEN_SWINGS
3. Assicurati che il braccio non si muova durante la sessione

### Conta a scoppi (0, 0, 0, 5, 0, 0, 0, 3...)
1. Aumenta MIN_TIME_BETWEEN_SWINGS
2. Prova a posizionare il dispositivo diversamente al polso
3. Possibile problema hardware - riavvia il dispositivo

### Calcoli diversi ogni volta
- Normale! I sensori sono soggetti a variabilità
- Test multipli e fai una media
- Una variazione del ±1 swing è considerata buona

## Consigli Finali

1. **Pazienza:** La calibrazione richiede qualche tentativo
2. **Consistenza:** Indossa il dispositivo sempre nello stesso modo
3. **Note:** Scrivi le impostazioni che funzionano per te
4. **Test:** Fai test in condizioni diverse (range interno, esterno, tempo, ecc.)
5. **Backup:** Tieni nota dei valori che funzionano bene

Una volta calibrato, il tuo "Golf Range" trackerà accuratamente i tuoi swing! ⛳
