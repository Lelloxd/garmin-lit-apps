using Toybox.Application;
using Toybox.WatchUi;

class GolfRangeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        // 1. Crea prima la View
        var view = new GolfRangeView();
        
        // 2. Crea il Delegate PASSANDO la view (risolve l'errore degli argomenti)
        var delegate = new GolfRangeDelegate(view);
        
        // 3. Collega il delegate alla view (così la view può leggere i dati)
        view.setDelegate(delegate);
        
        return [ view, delegate ];
    }

}

function getApp() {
    return Application.getApp();
}
