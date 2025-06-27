class HP2RandoSetupScrollClient extends UWindowScrollingDialogClient;

function Created()
{
    FixedAreaClass = None;
    bShowHorizSB=False;
    bShowVertSB=True;
    
    Super.Created();
}

defaultproperties
{
    ClientClass=Class'HP2RandoSetupWindow'
}