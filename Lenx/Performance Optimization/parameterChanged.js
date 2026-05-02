// ====== 全域控制變數 ======
var autoUpdate = false;  // 預設為手動模式
var updatePending = false;  // 標記是否有待更新

// ====== 記錄參數變化 ======
function parameterChanged() {
    updatePending = true;
    
    if (autoUpdate) {
        // 自動模式:立即更新
        updateAll();
    } else {
        // 手動模式:標記待更新,改變按鈕顏色
        try {
            ggbApplet.setColor("更新按鈕", 255, 0, 0);  // 變紅色提示
        } catch(e) {}
    }
}

// ====== 執行更新 ======
function updateAll() {
    UpdateConstruction();
    updatePending = false;
    
    // 恢復按鈕顏色
    try {
        ggbApplet.setColor("更新按鈕", 0, 100, 0);  // 變綠色
    } catch(e) {}
}

// ====== 切換更新模式 ======
function toggleMode() {
    autoUpdate = !autoUpdate;
    
    if (autoUpdate) {
        ggbApplet.evalCommand("SetCaption(模式按鈕, \"模式:自動✓\")");
        ggbApplet.setColor("模式按鈕", 0, 150, 0);
        
        // 切換到自動模式時,如果有待更新就立即更新
        if (updatePending) {
            updateAll();
        }
    } else {
        ggbApplet.evalCommand("SetCaption(模式按鈕, \"模式:手動\")");
        ggbApplet.setColor("模式按鈕", 100, 100, 100);
    }
}

// ====== 重置所有參數 ======
function resetParameters() {
    // 重置到預設值
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