class HP2RCauldronMixing injects CauldronMixing;

defaultproperties
{
    CollisionHeight=15 //Actually matches the mesh, instead of being outrageously tall
    CentreOffset=(X=0.00,Y=0.00,Z=0.00) //For targeting with spells, this is normally offset
    bPersistent=True //Might as well
    bAlignBottomAlways=True //Force the mesh to be aligned to the bottom of the collision
    Physics=PHYS_Falling //Vanilla default is PHYS_None
}