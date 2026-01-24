using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Activity;
using Toybox.Lang;
using Toybox.System;

class GolfRangeView extends WatchUi.View {

    private var _delegate;
    private var _screenHeight;
    private var _screenWidth;

    function initialize() {
        View.initialize();
    }

    // Passiamo il delegate per accedere ai dati degli swing
    function setDelegate(del) {
        _delegate = del;
    }

    // Ottimizzazione: carichiamo le dimensioni dello schermo solo una volta
    function onLayout(dc) {
        _screenHeight = dc.getHeight();
        _screenWidth = dc.getWidth();
    }

    function onUpdate(dc) {
        // 1. Reset dello sfondo
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // 2. Recupero dati (Swing dal delegate, Calorie dal sistema)
        var swingCount = (_delegate != null) ? _delegate.getSwingCount() : 0;
        var isRecording = (_delegate != null) ? _delegate.getIsRecording() : false;
        
        var info = Activity.getActivityInfo();
        var calories = (info != null && info.calories != null) ? info.calories : 0;

        // --- ORARIO ATTUALE ---
        var clockTime = System.getClockTime();
        var timeStr = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_screenWidth / 2, _screenHeight * 0.03, Graphics.FONT_XTINY, timeStr, Graphics.TEXT_JUSTIFY_CENTER);

        // --- DISEGNO INTERFACCIA ---
        // Indicatore di Stato (Pallino colorato + Testo)
        var statusColor = isRecording ? Graphics.COLOR_GREEN : Graphics.COLOR_RED;
        dc.setColor(statusColor, Graphics.COLOR_TRANSPARENT);
        var statusText = isRecording ? "RECORDING" : "STOPPED";
        dc.drawText(_screenWidth / 2, _screenHeight * 0.12, Graphics.FONT_XTINY, statusText, Graphics.TEXT_JUSTIFY_CENTER);

        // --- SEZIONE CENTRALE: SWINGS ---
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_screenWidth / 2, _screenHeight * 0.20, Graphics.FONT_NUMBER_HOT, swingCount.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_screenWidth / 2, _screenHeight * 0.48, Graphics.FONT_TINY, "SWINGS", Graphics.TEXT_JUSTIFY_CENTER);

        // --- SEZIONE INFERIORE: CALORIE ---
        // Linea decorativa sottile
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(_screenWidth * 0.2, _screenHeight * 0.60, _screenWidth * 0.8, _screenHeight * 0.60);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_screenWidth / 2, _screenHeight * 0.64, Graphics.FONT_SMALL, calories.toString() + " kcal", Graphics.TEXT_JUSTIFY_CENTER);

        var btnWidth = _screenWidth;
        var btnHeight = _screenHeight*0.20;
        var btnX = (_screenWidth - btnWidth) / 2;
        var btnY = _screenHeight * 0.80; // Posizionato sopra il fondo per visibilità

        if (isRecording) {
            // Bottone ROSSO per STOP
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(btnX, btnY, btnWidth, btnHeight, 8);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(_screenWidth / 2, btnY + (btnHeight / 2), Graphics.FONT_TINY, "STOP", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            // Bottone VERDE per START
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(btnX, btnY, btnWidth, btnHeight, 8);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT); // Testo nero su verde per contrasto
            dc.drawText(_screenWidth / 2, btnY + (btnHeight / 2), Graphics.FONT_TINY, "START", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function onHide() {
    }
}