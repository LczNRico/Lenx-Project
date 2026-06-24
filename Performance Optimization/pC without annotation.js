
var autoUpdate = false;
var updatePending = false;


function parameterChanged() {
    updatePending = true;
    
    if (autoUpdate) {
        updateAll();
    } else {
        try {
            ggbApplet.setColor("更新按鈕", 255, 0, 0);
        } catch(e) {}
    }
}

function updateAll() {
    UpdateConstruction();
    updatePending = false;
    try {
        ggbApplet.setColor("更新按鈕", 0, 100, 0);
    } catch(e) {}
}

function toggleMode() {
    autoUpdate = !autoUpdate;
    
    if (autoUpdate) {
        ggbApplet.evalCommand("SetCaption(模式按鈕, \"模式:自動✓\")");
        ggbApplet.setColor("模式按鈕", 0, 150, 0);
        if (updatePending) {
            updateAll();
        }
    } else {
        ggbApplet.evalCommand("SetCaption(模式按鈕, \"模式:手動\")");
        ggbApplet.setColor("模式按鈕", 100, 100, 100);
    }
}

function resetParameters() {
    ggbApplet.evalCommand("SetValue(α, 5)");
    ggbApplet.evalCommand("SetValue(β, 5)");
    ggbApplet.evalCommand("SetValue(n_{Lens}, 1.5)");
    ggbApplet.evalCommand("SetValue(n_{Out}, 1.0)");
    ggbApplet.evalCommand("SetCoords(A, -5, 0)");
    ggbApplet.evalCommand("SetCoords(B, 5, 0)");
    ggbApplet.evalCommand("SetCoords(Light1, -10, 3)");
    ggbApplet.evalCommand("SetCoords(Light2, 0, 3)");

    updateAll();
}