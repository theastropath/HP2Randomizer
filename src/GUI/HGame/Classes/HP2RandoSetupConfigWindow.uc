class HP2RandoSetupConfigWindow extends UWindowFramedWindow;

function Created()
{
    Super.Created();
    bSizable = False;
    bStatusBar = True;
    bAcceptsHotKeys = True;
    bTransient = False;
    bUWindowActive = True;

    CloseBox.HideWindow(); //Don't show the close button, only allow closing via the Done button

    WinLeft = (ParentWindow.WinWidth - WinWidth) / 2;
    WinTop = (ParentWindow.WinHeight - WinHeight) / 2;

    SetAcceptsFocus();

}

function Tick(float Delta)
{
    if(ParentWindow.ActiveWindow != Self){
        ActivateWindow(0, False);
    }
}

defaultproperties
{
    ClientClass=Class'HP2RandoSetupScrollClient'
    WindowTitle="HP2 Randomizer Settings"
}