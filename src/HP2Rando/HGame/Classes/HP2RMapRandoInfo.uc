class HP2RMapRandoInfo extends info;

var string LastGameState;

function bool SetGameState (string newState)
{
    if (LastGameState == newState) return false;

    LastGameState = newState;

    return true;
}

defaultproperties
{
    bPersistent=True
}
