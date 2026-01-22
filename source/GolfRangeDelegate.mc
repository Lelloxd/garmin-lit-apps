using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;
using Toybox.ActivityRecording;
using Toybox.Sensor;
using Toybox.Math;
using Toybox.Attention;

class GolfRangeDelegate extends WatchUi.BehaviorDelegate {

    var session = null;
    var swingCount = 0;
    var isRecording = false;
    var totalDistance = 0;
    
    // Variabili per il rilevamento dello swing
    var lastSwingTime = 0;
    var lastUpdateTime = 0;

    var SWING_THRESHOLD = 5000; // Valore di default
    const MIN_TIME_BETWEEN_SWINGS = 3000; // Millisecondi tra uno swing e l'altro

    function initialize() {
        BehaviorDelegate.initialize();

        // Carica la soglia salvata, altrimenti usa il valore di default
        var storedThreshold = Application.getApp().getProperty("swingThreshold");
        if (storedThreshold != null) {
            SWING_THRESHOLD = storedThreshold;
        }

        // Attiva l'accelerometro a 25Hz (campionamento medio)
        var options = {
            :period => 1,
            :sampleRate => 25,
            :enableAccelerometer => true
        };
        Sensor.registerSensorDataListener(method(:onSensor), options);
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

        // Tasto BACK per tornare indietro
        if (key == WatchUi.KEY_ESC) {
            return false;
        }

        return false;
    }

    // Gestione dello swipe per aprire il menu delle impostazioni
    function onSwipe(swipeEvent) {
        if (swipeEvent.getDirection() == WatchUi.SWIPE_LEFT) {
            var menu = new WatchUi.Menu2({:title=>"Threshold"});
            // Aggiunge le opzioni da 3000 a 15000
            for (var i = 3000; i <= 15000; i += 1000) {
                // L'ID dell'item sarà il valore stesso della soglia
                menu.addItem(new WatchUi.MenuItem(i.toString(), null, i, null));
            }

            var delegate = new ThresholdMenuDelegate(self);
            WatchUi.pushView(menu, delegate, WatchUi.SLIDE_LEFT);
            return true;
        }

        return false;
    }

    function startRecording() {
        if (Toybox has :ActivityRecording) {
            try {
                // Crea la sessione definendola come GOLF
                session = ActivityRecording.createSession({
                    :name => "Golf Range",
                    :sport => ActivityRecording.SPORT_GOLF,
                    :subSport => ActivityRecording.SUB_SPORT_GENERIC
                });
                session.start();
                isRecording = true;
                swingCount = 0; // Reset contatore
                lastSwingTime = 0;
                totalDistance = 0;

                // Feedback vibrazione (avvio registrazione)
                if (Toybox has :Attention) {
                    var vibeData = [new Attention.VibeProfile(30, 200)];
                    Attention.vibrate(vibeData);
                }

                WatchUi.requestUpdate();
                System.println("Golf Range Session Started");
            } catch (e) {
                System.println("Error starting session: " + e.getErrorMessage());
            }
        }
    }

    function stopRecording() {
        if (session != null && isRecording) {
            try {
                session.stop();
                session.save(); // Salva e chiude, calcolando calorie ecc.
                session = null;
                isRecording = false;

                // Feedback vibrazione (fine registrazione)
                if (Toybox has :Attention) {
                    var vibeData = [
                        new Attention.VibeProfile(50, 100),
                        new Attention.VibeProfile(0, 50),
                        new Attention.VibeProfile(50, 100)
                    ];
                    Attention.vibrate(vibeData);
                }

                WatchUi.requestUpdate();
                System.println("Golf Range Session Saved. Total Swings: " + swingCount);
            } catch (e) {
                System.println("Error stopping session: " + e.getErrorMessage());
            }
        }
    }

    // Logica di rilevamento Swing
    function onSensor(sensorData as Sensor.SensorData) as Void {
        if (!isRecording) { return; }

        var acc = sensorData.accelerometerData;
        if (acc != null && acc.x != null && acc.y != null && acc.z != null) {
            var x = acc.x[0];
            var y = acc.y[0];
            var z = acc.z[0];

            // Calcola la magnitudo del vettore accelerazione
            var magnitude = Math.sqrt((x*x) + (y*y) + (z*z)).toNumber();

            // Controllo se supera la soglia e se è passato abbastanza tempo
            var now = System.getTimer();
            if (magnitude > SWING_THRESHOLD && (now - lastSwingTime > MIN_TIME_BETWEEN_SWINGS)) {
                swingCount++;
                lastSwingTime = now;
                lastUpdateTime = now;

                // Feedback vibrazione (swing rilevato)
                if (Toybox has :Attention) {
                    var vibeData = [new Attention.VibeProfile(20, 50)];
                    Attention.vibrate(vibeData);
                }

                WatchUi.requestUpdate(); // Aggiorna lo schermo
                System.println("Swing detected! Total: " + swingCount + " (magnitude: " + magnitude + ")");
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

    function getTotalDistance() {
        return totalDistance;
    }

    // Metodo per aggiornare la soglia dal menu
    function setSwingThreshold(newThreshold) {
        SWING_THRESHOLD = newThreshold;
        Application.getApp().setProperty("swingThreshold", newThreshold);
        System.println("New Swing Threshold set to: " + newThreshold);
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
