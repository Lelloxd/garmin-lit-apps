using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;
using Toybox.Application.Properties as Props;
using Toybox.ActivityRecording;
using Toybox.Sensor;
using Toybox.FitContributor;
using Toybox.Math;
using Toybox.Attention;
using Toybox.Activity;

class GolfRangeDelegate extends WatchUi.BehaviorDelegate {

    var session = null;
    var swingCount = 0;
    var isRecording = false;
    var totalDistance = 0;
    var parentView = null;
    var lastAction = 0; // 0: none, 1: saved, 2: discarded

    // Campi FIT per il conteggio swing
    const SWING_COUNT_FIELD_ID = 0;
    var _swingCountField = null;
    
    // Variabili per il rilevamento dello swing
    var lastSwingTime = 0;
    var lastUpdateTime = 0;

    var SWING_THRESHOLD = 2000; // Valore di default
    const MIN_TIME_BETWEEN_SWINGS = 1500; // Millisecondi tra uno swing e l'altro

    const SWING_GRAPH_FIELD_ID = 1;      // Grafico nel tempo
    var _swingGraphField = null;

function initialize(view) {
        BehaviorDelegate.initialize();
        parentView = view;

        // Recupero sicuro della soglia
        var storedThreshold = null;
        try {
            storedThreshold = Props.getValue("swingThreshold");
        } catch (e) {
            System.println("Property not found, using default");
        }

        if (storedThreshold != null && (storedThreshold instanceof Toybox.Lang.Number)) {
            SWING_THRESHOLD = storedThreshold;
        } else if (storedThreshold != null) {
            // Se per qualche motivo è una stringa, la convertiamo
            SWING_THRESHOLD = storedThreshold.toNumber();
        }

        // Resto del codice dell'accelerometro...
        var options = {
            :period => 1,
            :sampleRate => 25,
            :enableAccelerometer => true
        };
        if (Sensor has :registerSensorDataListener) {
            Sensor.registerSensorDataListener(method(:onSensor), options);
        } else {
            System.println("Warning: registerSensorDataListener not supported on this device/firmware.");
        }
    }

    // Gestione del pulsante fisico - ENTER per avviare/fermare
    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_START) {
            if (isRecording) {
                stopRecording();
            } else {
                startRecording();
            }
            return true;
        }

        // Aggiungiamo il supporto al tasto MENU per orologi senza touch (es. Fenix, Forerunner)
        if (key == WatchUi.KEY_MENU) {
            openThresholdMenu();
            return true;
        }

        // Tasto BACK per tornare indietro
        if (key == WatchUi.KEY_ESC) {
            return false;
        }

        return false;
    }

    // Gestione dello swipe per aprire il menu delle impostazioni
    function onSwipe(swipeEvent) {
        if (swipeEvent.getDirection() == WatchUi.SWIPE_LEFT) {
            openThresholdMenu();
            return true;
        }

        return false;
    }

    function onTap(clickEvent) {
        var coords = clickEvent.getCoordinates();
        var y = coords[1];
        
        // Se l'utente tocca la parte bassa dello schermo (dove c'è il bottone)
        if (y > (System.getDeviceSettings().screenHeight * 0.70)) {
            if (isRecording) {
                stopRecording();
            } else {
                startRecording();
            }
            return true;
        }
        return false;
    }

    // Funzione helper per aprire il menu (usata sia da Swipe che da Tasto)
    function openThresholdMenu() {
        var menu = new WatchUi.Menu2({:title=>"Threshold"});
        // Aggiunge le opzioni da 1500 a 5000
        for (var i = 1500; i <= 5000; i += 250) {
            var subLabel = null;
            // Evidenzia il valore attuale
            if (i == SWING_THRESHOLD) {
                subLabel = "Current";
            }
            // L'ID dell'item sarà il valore stesso della soglia
            menu.addItem(new WatchUi.MenuItem(i.toString(), subLabel, i, null));
        }

        var delegate = new ThresholdMenuDelegate(self);
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_LEFT);
    }

function startRecording() {
        if (Toybox has :ActivityRecording) {
            try {
                // Trucco: definiamo il dizionario separatamente
                // e usiamo le costanti che l'orologio riconosce.
                // Se mettiamo il dizionario in una variabile locale 'options', 
                // il compilatore è meno aggressivo nel controllo dei tipi.
                
                var sportType = ActivityRecording.SPORT_GENERIC;
                if (ActivityRecording has :SPORT_GOLF) {
                    sportType = ActivityRecording.SPORT_GOLF;
                }

                var options = {
                    :name => "Golf Range",
                    :sport => sportType,
                    :subSport => ActivityRecording.SUB_SPORT_GENERIC
                };

                // Passiamo 'options' direttamente
                session = ActivityRecording.createSession(options);

                // Inizializzazione campi FIT
                _swingCountField = session.createField("swing_count", 0, FitContributor.DATA_TYPE_UINT16, {:mesgType => FitContributor.MESG_TYPE_SESSION});
                _swingGraphField = session.createField("swing_per_moment", 1, FitContributor.DATA_TYPE_UINT16, {:mesgType => FitContributor.MESG_TYPE_RECORD});

                session.start();
                isRecording = true;
                swingCount = 0;
                lastSwingTime = 0;
                lastAction = 0;

                if (Toybox has :Attention) {
                    var vibeData = [new Attention.VibeProfile(30, 200)];
                    Attention.vibrate(vibeData);
                }

                WatchUi.requestUpdate();
            } catch (e) {
                System.println("Errore Start: " + e.getErrorMessage());
            }
        }
    }

    function stopRecording() {
        if (session != null && isRecording) {
            // 1. SCRIVI I DATI PRIMA
            if (_swingCountField != null) {
                _swingCountField.setData(swingCount);
            }
            
            // 2. FERMA TEMPORANEAMENTE
            session.stop();
            isRecording = false; // Fermati graficamente
            
            // 3. RECUPERO INFO PER CONTROLLO
            var info = Activity.getActivityInfo();
            var calories = (info != null && info.calories != null) ? info.calories : 0;
            
            // 4. CHIEDI O SCARTA
            if (swingCount > 0 || calories > 0) {
                var menu = new WatchUi.Menu2({:title=>"Activity Paused"});
                menu.addItem(new WatchUi.MenuItem("Save", "Swings: " + swingCount + " | Kcal: " + calories, "save", null));
                menu.addItem(new WatchUi.MenuItem("Discard", null, "discard", null));
                menu.addItem(new WatchUi.MenuItem("Resume", null, "resume", null));
                WatchUi.pushView(menu, new SaveMenuDelegate(self), WatchUi.SLIDE_UP);
            } else {
                handleSaveDecision("discard"); // scarta direttamente
            }
            
            WatchUi.requestUpdate();
        }
    }

    function handleSaveDecision(action) {
        if (action.equals("save")) {
            session.save();
            lastAction = 1; // saved
        } else if (action.equals("discard")) {
            session.discard();
            lastAction = 2; // discarded
        } else if (action.equals("resume")) {
            session.start();
            isRecording = true;
            lastAction = 0;
            WatchUi.requestUpdate();
            return; // no vibration for resume
        }
        
        // VIBRAZIONE FEEDBACK LUNGA
        if (Toybox has :Attention) {
            var vibeData = [
                new Attention.VibeProfile(100, 500)
            ];
            Attention.vibrate(vibeData);
        }

        WatchUi.requestUpdate();
    }

    function onSensor(sensorData as Sensor.SensorData) as Void {
        if (!isRecording) { return; }

        var acc = sensorData.accelerometerData;
        if (acc != null && acc.x != null && acc.y != null && acc.z != null) {
            var x = acc.x[0];
            var y = acc.y[0];
            var z = acc.z[0];

            var magnitude = Math.sqrt((x*x) + (y*y) + (z*z)).toNumber();
            var now = System.getTimer();

            if (magnitude > SWING_THRESHOLD && (now - lastSwingTime > MIN_TIME_BETWEEN_SWINGS)) {
                swingCount++;
                lastSwingTime = now;

                if (_swingCountField != null) {
                    _swingCountField.setData(swingCount.toNumber());
                }
                
                if (_swingGraphField != null) {
                    // Mandiamo un valore più alto (es. 10) per rendere il picco più visibile nel grafico
                    _swingGraphField.setData(10); 
                }

                if (Toybox has :Attention) {
                    var vibeData = [new Attention.VibeProfile(20, 50)];
                    Attention.vibrate(vibeData);
                }

                WatchUi.requestUpdate(); 
            }
        }
    }

    // Getter per accedere ai dati dal delegate
    function getSwingCount() {
        return swingCount;
    }

    function getIsRecording() {
        return isRecording;
    }

    function getLastAction() {
        return lastAction;
    }

    function getTotalDistance() {
        return totalDistance;
    }

    // Metodo per aggiornare la soglia dal menu
    function setSwingThreshold(newThreshold) {
        SWING_THRESHOLD = newThreshold;
        // Sostituisci setProperty con questo:
        Props.setValue("swingThreshold", newThreshold);
    }

}

// Delegate per il menu di selezione della soglia
class ThresholdMenuDelegate extends WatchUi.Menu2InputDelegate {
    var _mainDelegate;

    function initialize(mainDelegate) {
        Menu2InputDelegate.initialize();
        _mainDelegate = mainDelegate;
    }

    function onSelect(item) {
        var id = item.getId();
        if (id != null) {
            // L'ID è il valore della soglia che abbiamo impostato
            _mainDelegate.setSwingThreshold(id as Toybox.Lang.Number);
        }
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

// Delegate per il menu di conferma salvataggio
class SaveMenuDelegate extends WatchUi.Menu2InputDelegate {
    var _mainDelegate;

    function initialize(mainDelegate) {
        Menu2InputDelegate.initialize();
        _mainDelegate = mainDelegate;
    }

    function onSelect(item) {
        var id = item.getId();
        if (id != null && id instanceof Toybox.Lang.String) {
            _mainDelegate.handleSaveDecision(id);
        }
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        _mainDelegate.handleSaveDecision("resume");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
