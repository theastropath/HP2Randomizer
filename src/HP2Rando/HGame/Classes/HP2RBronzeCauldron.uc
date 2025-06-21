class HP2RBronzeCauldron injects bronzecauldron;

//Fix the absurd collision size of these cauldrons.
/*
event PreBeginPlay()
{
    local vector newLoc;

    Super.PreBeginPlay();

    //Adjust their location since they were placed with no prepivot in mind
    newLoc = Location - PrePivot;
    SetLocation2(newLoc);
    log(self$" location adjusted to "$Location);
}
*/

defaultproperties
{
    CollisionHeight=24
    CentreOffset=(X=0.00,Y=0.00,Z=0.00) //For targeting with spells, this is normally offset
    bPersistent=True //Might as well just make it guaranteed (The ones I checked were all manually set true)
    bAlignBottomAlways=True //Force the mesh to be aligned to the bottom of the collision
    Physics=PHYS_Falling //Vanilla default is PHYS_None
}