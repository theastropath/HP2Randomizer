//Fix the absurd collision size of these cauldrons.
class HP2RBronzeCauldron injects bronzecauldron;

function Reset()
{
    log("Attempting to reset cauldron "$Self$" in animation "$AnimSequence);
    switch(AnimSequence){
        case 'Fighter':
        case 'sit':
            return; //Cauldron hasn't been touched yet, just leave
    }

    log("Resetting cauldron "$Self);
    bOpened=False; //Bronze cauldron doesn't *actually* modify bOpened, despite having the property
    eVulnerableToSpell = Default.eVulnerableToSpell;
    bProjTarget = Default.bProjTarget;
    PlayAnim('sit');
    GoToState('waitforspell');
}

defaultproperties
{
    CollisionHeight=24
    CentreOffset=(X=0.00,Y=0.00,Z=0.00) //For targeting with spells, this is normally offset
    bPersistent=True //Might as well just make it guaranteed (The ones I checked were all manually set true)
    bAlignBottomAlways=True //Force the mesh to be aligned to the bottom of the collision
    Physics=PHYS_Falling //Vanilla default is PHYS_None
}