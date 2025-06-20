class HP2RSwapItems extends HP2RActorsBase transient;

//Not going to bother with config in this HP2 version - no one ever touched it in DXRando

function FirstEntry()
{
    local int i;
    local float chance;
    local string c;
    local class<Actor> classes[10];

    Super.FirstEntry();

    ClearClassesList(classes);
    i=0;
    classes[i++]=class'HGame.GenericSpawner';
    classes[i++]=class'HGame.chestbronze';
    //TODO: Include more classes, like the bronze cauldrons (that aren't bPersistent normally)
    //Maybe non-persistent things should be shuffled together amongst themselves?
    chance = 100.0;
    l("swapping pool: GenericSpawner and chestbronze, chance: "$chance);
    SwapAllPooled(classes,chance);
    l("done swapping pool: GenericSpawner and chestbronze");
}
