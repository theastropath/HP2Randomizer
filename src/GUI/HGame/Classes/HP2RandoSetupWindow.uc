//This is where we can set up new flags to config things like chances for rando
class HP2RandoSetupWindow extends UWindowDialogClientWindow;

var UWindowEditControl seedEdit;
var UWindowEditControl spellWandSpeedMinEdit;
var UWindowEditControl spellWandSpeedMaxEdit;
var ScalingComboBox    spellArrowDirModeEdit;
var UWindowEditControl spawnerRandoEdit;
var UWindowEditControl looseItemRandoEdit;
var UWindowEditControl knickknackRandoEdit;
var UWindowEditControl vendorSwapEdit;
var UWindowEditControl vendorPriceMinEdit;
var UWindowEditControl vendorPriceMaxEdit;
var UWindowEditControl duelPrizeMinEdit;
var UWindowEditControl duelPrizeMaxEdit;
var UWindowCheckbox    vendorExtraLocsEdit;

var HGameButton doneButton;

var Color colWhite,colBlack;

var bool bClosing;



const BUTTON_WIDTH=64;
const BUTTON_HEIGHT=32;

const OPTION_WIDTH=125;
const OPTION_HEIGHT=15;

const SETTINGS_START = 5.0;
const SETTINGS_OFFSET= 20.0;
const DONE_BUTTON_OFFSET = 100.0;
const MINOR_SEPARATION_OFFSET = 10; //For adding slight extra space to separate min/max related options from others



//#region Window Layout
function Created()
{
    local int ControlWidth, ControlLeft, ControlRight;
    local int CenterWidth, CenterPos, i;
    local float ControlOffset;

    HPConsole(Root.Console).bLockMenus=True; //Prevent the menu from being opened
    SetAcceptsFocus();
    bUWindowActive = True;
    
    ControlWidth = WinWidth/10;
    ControlLeft = (WinWidth/5 - ControlWidth)/2;
    ControlRight = WinWidth/5 + ControlLeft;
    CenterWidth = (WinWidth/4)*3;
    CenterPos = (WinWidth - CenterWidth)/2;
    
    ControlOffset=SETTINGS_START;

    log("Created RandoSetupWindow!  ControlLeft: "$ControlLeft$"  ControlOffset: "$ControlOffset$"   WinWidth: "$WinWidth);

    seedEdit = CreateNumInput("Seed: ", "", 6, ControlLeft, ControlOffset);

    //New Section
    ControlOffset+=SETTINGS_OFFSET;

    ControlOffset+=SETTINGS_OFFSET;
    CreateTextLabel("Spell Lessons ",ControlLeft,ControlOffset);

    //Spell Lesson Arrow Rando Mode
    ControlOffset+=SETTINGS_OFFSET;
    spellArrowDirModeEdit = CreateComboBox("Spell Lesson Arrow Mode: ",ControlLeft,ControlOffset);
    spellArrowDirModeEdit.AddItem("Vanilla Arrows","Vanilla");
    spellArrowDirModeEdit.AddItem("Existing Arrow Chaos","ExistingChaos");
    spellArrowDirModeEdit.AddItem("Full Arrow Chaos","FullChaos");
    spellArrowDirModeEdit.AddItem("Existing Arrow Consistent","ConsistentArrows");
    spellArrowDirModeEdit.AddItem("Chaos Pattern","PatternChaos");
    SetComboBoxStartValue(spellArrowDirModeEdit,"PatternChaos"); //Default to Chaos Pattern

    ControlOffset+=MINOR_SEPARATION_OFFSET;

    //Minimum 
    ControlOffset+=SETTINGS_OFFSET;
    spellWandSpeedMinEdit = CreateNumInput("Spell Lesson Wand Speed Min %: ", "75", 3, ControlLeft, ControlOffset);

    ControlOffset+=SETTINGS_OFFSET;
    spellWandSpeedMaxEdit = CreateNumInput("Spell Lesson Wand Speed Max %: ", "150", 3, ControlLeft, ControlOffset);

    //New section
    ControlOffset+=SETTINGS_OFFSET;

    ControlOffset+=SETTINGS_OFFSET;
    CreateTextLabel("Item Swapping ",ControlLeft,ControlOffset);

    //Spawner Rando odds
    ControlOffset+=SETTINGS_OFFSET;
    spawnerRandoEdit = CreateNumInput("Spawner Rando %: ", "100", 3, ControlLeft, ControlOffset);

    //Loose Item Rando odds
    ControlOffset+=SETTINGS_OFFSET;
    looseItemRandoEdit = CreateNumInput("Loose Item Rando %: ", "100", 3, ControlLeft, ControlOffset);

    //Knick-Knack Rando odds
    ControlOffset+=SETTINGS_OFFSET;
    knickknackRandoEdit = CreateNumInput("Knick-Knack Rando %: ", "100", 3, ControlLeft, ControlOffset);

    //New section
    ControlOffset+=SETTINGS_OFFSET;

    ControlOffset+=SETTINGS_OFFSET;
    CreateTextLabel("Vendors ",ControlLeft,ControlOffset);

    //Vendor Swap odds
    ControlOffset+=SETTINGS_OFFSET;
    vendorSwapEdit = CreateNumInput("Vendor Swap %: ", "100", 3, ControlLeft, ControlOffset);

    ControlOffset+=SETTINGS_OFFSET;
    vendorExtraLocsEdit = CreateCheckbox("Additional Vendor Locations: ", true, ControlLeft, ControlOffset);

    ControlOffset+=MINOR_SEPARATION_OFFSET;

    ControlOffset+=SETTINGS_OFFSET;
    vendorPriceMinEdit = CreateNumInput("Vendor Price Min %: ", "50", 3, ControlLeft, ControlOffset);

    ControlOffset+=SETTINGS_OFFSET;
    vendorPriceMaxEdit = CreateNumInput("Vendor Price Max %: ", "150", 3, ControlLeft, ControlOffset);

    ControlOffset+=MINOR_SEPARATION_OFFSET;

    ControlOffset+=SETTINGS_OFFSET;
    duelPrizeMinEdit = CreateNumInput("Duel Prize Min %: ", "50", 3, ControlLeft, ControlOffset);

    ControlOffset+=SETTINGS_OFFSET;
    duelPrizeMaxEdit = CreateNumInput("Duel Prize Max %: ", "200", 3, ControlLeft, ControlOffset);

    //DONE button, well below the other settings
    ControlOffset+=DONE_BUTTON_OFFSET;
    doneButton = CreateDoneButton("DONE",(WinWidth-BUTTON_WIDTH)/2,ControlOffset);

    DesiredHeight=ControlOffset;  //Tell the scroll client how tall this should be
}
//#endregion

//#region Convenience
function UWindowLabelControl CreateTextLabel(String text, int x, int y)
{
    local UWindowLabelControl newLabel;

    newLabel = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 
                                                x, //X
                                                y, //Y 
                                                OPTION_WIDTH, //Width
                                                OPTION_HEIGHT)); //Height
    newLabel.SetText(text);
    newLabel.SetFont(F_LargeBold);
    newLabel.Align = TA_Center;
    newLabel.TextColor=colWhite;

    return newLabel;
}

function HGameButton CreateDoneButton(String text, int x, int y)
{
    local HGameButton newButt;


    newButt = HGameButton(CreateControl(class'HGameButton', 
                                                x, //X
                                                y * 1.2, //Y - TODO: Figure out why this multiplier is needed (related to texture size, maybe?)
                                                BUTTON_WIDTH, //Width
                                                BUTTON_HEIGHT)); //Height
    newButt.ShowWindow();
    newButt.CancelAcceptsFocus();
    newButt.Align = TA_Center;
    newButt.SetText(text);

    newButt.SetFont(4);
    newButt.TextColor.R = 255;
    newButt.TextColor.G = 255;
    newButt.TextColor.B = 255;

    newButt.UpTexture =   class'ShortCutButton'.Default.UpButtonTexture;
    newButt.DownTexture = class'ShortCutButton'.Default.DownButtonTexture;
    newButt.OverTexture = class'ShortCutButton'.Default.UpButtonTexture;

    //newButt.bUseRegion = True;
    newButt.UpRegion.W = newButt.WinWidth;
    newButt.UpRegion.H = newButt.WinHeight;

    newButt.DownRegion.W = newButt.WinWidth;
    newButt.DownRegion.H = newButt.WinHeight;

    newButt.DisabledRegion.W = newButt.WinWidth;
    newButt.DisabledRegion.H = newButt.WinHeight;

    newButt.OverRegion.W = newButt.WinWidth;
    newButt.OverRegion.H = newButt.WinHeight;

    //newButt.Resized();

    return newButt;
}

function UWindowCheckbox CreateCheckbox(String text, bool startChecked, int x, int y)
{
    local UWindowCheckbox newCheck;
    newCheck = UWindowCheckbox(CreateControl(class'UWindowCheckbox', 
                                           x, //X
                                           y, //Y 
                                           OPTION_WIDTH, //Width
                                           OPTION_HEIGHT)); //Height
    newCheck.SetText(text);
    newCheck.SetHelpText("asdfasdf");
    newCheck.SetFont(F_Bold);
    newCheck.Align = TA_Left;
    newCheck.bChecked = startChecked;
    newCheck.TextColor=colWhite;

    return newCheck;
}

function UWindowEditControl CreateNumInput(String text, string startVal, int length, int x, int y)
{
    local UWindowEditControl newWin;
    newWin = UWindowEditControl(CreateControl(class'UWindowEditControl', 
                                                x, //X
                                                y, //Y 
                                                OPTION_WIDTH, //Width
                                                OPTION_HEIGHT)); //Height
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
                                           OPTION_WIDTH, //Width
                                           OPTION_HEIGHT)); //Height
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
    switch(E)
    {
        case 2:
            switch(c){
                case doneButton:
                    Close();
                    break;
            }
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

    h = harry(GetPlayerOwner());

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
    h.SetGlobalString("HP2RLooseItemRando",looseItemRandoEdit.GetValue());
    h.SetGlobalString("HP2RKnickKnackRando",knickknackRandoEdit.GetValue());

    h.SetGlobalString("HP2RVendorsSwap",vendorSwapEdit.GetValue());
    h.SetGlobalBool("HP2RVendorExtraLocs",vendorExtraLocsEdit.bChecked);  //Bool saves as 1/0, not True/False
    h.SetGlobalFloat("HP2RVendorPriceMin",GetPercentFloatVal(vendorPriceMinEdit));
    h.SetGlobalFloat("HP2RVendorPriceMax",GetPercentFloatVal(vendorPriceMaxEdit));
    h.SetGlobalFloat("HP2RDuelPrizeMin",GetPercentFloatVal(duelPrizeMinEdit));
    h.SetGlobalFloat("HP2RDuelPrizeMax",GetPercentFloatVal(duelPrizeMaxEdit));

}
//#endregion

function Close (optional bool bByParent)
{
    local harry h;

    if (  !bClosing )
    {
        bClosing = True;
        SaveAllSettings();

        h = harry(GetPlayerOwner());
        if (h.hp2r!=None){
            h.hp2r.RandoEnter();
        }

        HPConsole(Root.Console).bLockMenus=False; //Allow opening the menu again

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