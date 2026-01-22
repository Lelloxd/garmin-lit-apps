using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class GolfRangeView extends WatchUi.View {

    var delegate;

    function initialize() {
        View.initialize();
        delegate = null;
    }

    function setDelegate(del) {
        delegate = del;
    }

    function onUpdate(dc) {
        // Pulisci lo schermo
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Colore testo bianco
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Ottieni i dati dal delegate
        var swingCount = (delegate != null) ? delegate.getSwingCount() : 0;
        var isRecording = (delegate != null) ? delegate.getIsRecording() : false;

        // Titolo in alto
        dc.drawText(width/2, 10, Graphics.FONT_SMALL, "GOLF RANGE", Graphics.TEXT_JUSTIFY_CENTER);

        // Separatore
        dc.drawLine(10, 30, width - 10, 30);

        // Stato registrazione
        var statusText = isRecording ? "● RECORDING" : "STOPPED";
        var statusColor = isRecording ? Graphics.COLOR_GREEN : Graphics.COLOR_RED;
        dc.setColor(statusColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, 40, Graphics.FONT_TINY, statusText, Graphics.TEXT_JUSTIFY_CENTER);

        // Ritorna al colore bianco
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Contatore Swing - GRANDE al centro
        var swingCountStr = swingCount.toString();
        dc.drawText(width/2, height/2 - 30, Graphics.FONT_NUMBER_HOT, swingCountStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Etichetta "Swings"
        dc.drawText(width/2, height/2 + 20, Graphics.FONT_MEDIUM, "SWINGS", Graphics.TEXT_JUSTIFY_CENTER);

        // Separatore
        dc.drawLine(10, height - 45, width - 10, height - 45);

        // Istruzioni in basso
        if (isRecording) {
            dc.drawText(width/2, height - 35, Graphics.FONT_XTINY, "Press START to Stop", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(width/2, height - 35, Graphics.FONT_XTINY, "Press START to Begin", Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Info aggiuntiva in basso a sinistra
        dc.drawText(5, height - 20, Graphics.FONT_XTINY, "v1.0.0", Graphics.TEXT_JUSTIFY_LEFT);
    }

    function onHide() {
    }

}
