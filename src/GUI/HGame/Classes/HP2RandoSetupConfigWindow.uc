class HP2RandoSetupConfigWindow extends UWindowFramedWindow;
function BeginPlay()
{
    Super.BeginPlay();
    WindowTitle = "HP2 Randomizer Settings";
    ClientClass = class'HP2RandoSetupWindow';
    SetAcceptsFocus();

    bTransient = False;
    bUWindowActive = True;
    bLeaveOnscreen = True;
    bAcceptsHotKeys = True;
    bSizable = False;
}

function Created()
{
    Super.Created();
    bLeaveOnscreen = True;
    bSizable = False;
    bStatusBar = True;

    SetSize(150, 300);
    WinLeft = (ParentWindow.WinWidth - WinWidth) / 2;
    WinTop = (ParentWindow.WinHeight - WinHeight) / 2;

    SetAcceptsFocus();

}
defaultproperties
{
}