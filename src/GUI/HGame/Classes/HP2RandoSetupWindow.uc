class HP2RandoSetupWindow extends UWindowDialogClientWindow;

var UWindowEditControl seedEdit;
var UWindowEditControl spellWandSpeedMinEdit;
var UWindowEditControl spellWandSpeedMaxEdit;
var ScalingComboBox    spellArrowDirModeEdit;
var UWindowEditControl spawnerRandoEdit;
var UWindowEditControl knickknackRandoEdit;

var Color colWhite,colBlack;

var bool bClosing;

//#region Window Layout
function Created()
{
    local int ControlWidth, ControlLeft, ControlRight;
    local int CenterWidth, CenterPos, i;
    local float ControlOffset;
    
    ControlWidth = WinWidth/10;
    ControlLeft = (WinWidth/5 - ControlWidth)/2;
    ControlRight = WinWidth/5 + ControlLeft;
    CenterWidth = (WinWidth/4)*3;
    CenterPos = (WinWidth - CenterWidth)/2;
    
    ControlOffset=5.0;

    log("Created RandoSetupWindow!  ControlLeft: "$ControlLeft$"  ControlOffset: "$ControlOffset$"   WinWidth: "$WinWidth);

    seedEdit = CreateNumInput("Seed: ", "", 6, ControlLeft, ControlOffset);

    //New Section
    ControlOffset+=20.0;

    //Spell Lesson Arrow Rando Mode
    ControlOffset+=20.0;
    spellArrowDirModeEdit = CreateComboBox("Spell Lesson Arrow Mode: ",ControlLeft,ControlOffset);
    spellArrowDirModeEdit.AddItem("Vanilla Arrows","Vanilla");
    spellArrowDirModeEdit.AddItem("Existing Arrow Chaos","ExistingChaos");
    spellArrowDirModeEdit.AddItem("Full Arrow Chaos","FullChaos");
    spellArrowDirModeEdit.AddItem("Existing Arrow Consistent","ConsistentArrows");
    spellArrowDirModeEdit.AddItem("Chaos Pattern","PatternChaos");
    SetComboBoxStartValue(spellArrowDirModeEdit,"PatternChaos"); //Default to Chaos Pattern

    //Minimum 
    ControlOffset+=20.0;
    spellWandSpeedMinEdit = CreateNumInput("Spell Lesson Wand Speed Min %: ", "75", 3, ControlLeft, ControlOffset);

    ControlOffset+=20.0;
    spellWandSpeedMaxEdit = CreateNumInput("Spell Lesson Wand Speed Max %: ", "150", 3, ControlLeft, ControlOffset);

    //New section
    ControlOffset+=20.0;

    //Spawner Rando odds
    ControlOffset+=20.0;
    spawnerRandoEdit = CreateNumInput("Spawner Rando %: ", "100", 3, ControlLeft, ControlOffset);

    //Knick-Knack Rando odds
    ControlOffset+=20.0;
    knickknackRandoEdit = CreateNumInput("Knick-Knack Rando %: ", "100", 3, ControlLeft, ControlOffset);

}
//#endregion

//#region Convenience
function UWindowEditControl CreateNumInput(String text, string startVal, int length, int x, int y)
{
    local UWindowEditControl newWin;
    newWin = UWindowEditControl(CreateControl(class'UWindowEditControl', 
                                                x, //X
                                                y, //Y 
                                                125, //Width
                                                15)); //Height
    newWin.SetText(text);
    newWin.SetHelpText("asdfasdf");
    newWin.SetFont(F_Bold);
    newWin.SetNumericOnly(True);
    newWin.SetNumericFloat(False);
    newWin.SetMaxLength(length);
    newWin.Align = TA_Left;
    newWin.SetValue(startVal);
    newWin.TextColor=colWhite;

    return newWin;
}

function float GetPercentFloatVal(UWindowEditControl box)
{
    local float f;
    local string s;

    s = box.GetValue();

    if (s=="") return 0.0;

    f = float(s)/100.0;

    return f;
}

function ScalingComboBox CreateComboBox(string text, int x, int y)
{
    local ScalingComboBox newWin;

    newWin = ScalingComboBox(CreateControl(class'ScalingComboBox', 
                                           x, //X
                                           y, //Y 
                                           125, //Width
                                           15)); //Height
    newWin.SetText(text);
    newWin.SetHelpText("asdfasdf");
    newWin.SetFont(F_Bold);
    newWin.TextColor=colWhite;
    newWin.SetEditTextColor(colBlack);
    newWin.EditBoxWidth = newWin.EditBoxWidth/2;
    newWin.SetEditable(False);
    newWin.SetButtons(False);

    return newWin;
}

function SetComboBoxStartValue(ScalingComboBox comboBox, string value2)
{
    local int i;

    i = comboBox.FindItemIndex2(value2);
    comboBox.SetSelectedIndex(i);
}
//#endregion

function Notify(UWindowDialogControl C, byte E)
{
    switch(c){
        case seedEdit:
            break;
    }
}

//#region Save Settings
//Populate the global string DB with these settings
function SaveAllSettings()
{
    local harry h;
    local int i;
    local string s;

    h = harry(Root.Console.Viewport.Actor);

    if (h==None){
        //Couldn't find Harry!
        return;
    }

    s = seedEdit.GetValue();
    if (s!=""){
        h.SetGlobalString("HP2RSeed",s); //This is an int, but no need to actually do the conversion here
    }

    h.SetGlobalString("HP2RSpellArrowDirMode",spellArrowDirModeEdit.GetValue2());
    h.SetGlobalFloat("HP2RSpellWandSpeedMin",GetPercentFloatVal(spellWandSpeedMinEdit));
    h.SetGlobalFloat("HP2RSpellWandSpeedMax",GetPercentFloatVal(spellWandSpeedMaxEdit));

    h.SetGlobalString("HP2RSpawnerRando",spawnerRandoEdit.GetValue());
    h.SetGlobalString("HP2RKnickKnackRando",knickknackRandoEdit.GetValue());
}
//#endregion

function Close (optional bool bByParent)
{
    local harry h;

    if (  !bClosing )
    {
        bClosing = True;
        SaveAllSettings();

        h = harry(Root.Console.Viewport.Actor);
        if (h.hp2r!=None){
            h.hp2r.RandoEnter();
        }

        Root.Console.CloseUWindow(); //This will also unpause the game
        Super.Close(bByParent);
        OwnerWindow.WindowDone(self);
    }
}

defaultproperties
{
    colBlack=(R=0,G=0,B=0)
    colWhite=(R=255,G=255,B=255)
}