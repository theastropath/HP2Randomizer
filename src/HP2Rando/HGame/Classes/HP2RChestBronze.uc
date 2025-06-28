class HP2RChestBronze injects chestbronze;

function Reset()
{
    log("Resetting chest "$Self);
    bOpened=False;
    eVulnerableToSpell = Default.eVulnerableToSpell;
    bProjTarget = Default.bProjTarget;
    GoToState('waitforspell');
}

defaultproperties
{
    bPersistent=True //Make them persistent by default, we'll reset the ones that need to be reset ourselves
}