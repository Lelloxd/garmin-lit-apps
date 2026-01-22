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
        var view = new GolfRangeView();
        var delegate = new GolfRangeDelegate();
        view.setDelegate(delegate);
        return [ view, delegate ];
    }

}

function getApp() {
    return Application.getApp();
}
