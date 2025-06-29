class HP2RSwapItems extends HP2RActorsBase transient;

//Not going to bother with config in this HP2 version - no one ever touched it in DXRando

function CheckConfig()
{
    InitRandoFlag("HP2RSpawnerRando","100");
    InitRandoFlag("HP2RLooseItemRando","100");
    InitRandoFlag("HP2RKnickKnackRando","100");
}

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
    classes[i++]=class'HGame.chestbronze'; //The other chest types subclass from this
    classes[i++]=class'HGame.BronzeCauldron';
    classes[i++]=class'HGame.CauldronMixing';

    ClearSkipActorList();
    AddSkipActorType(class'InvisibleSpawn');

    chance = GetGlobalFloat("HP2RSpawnerRando");
    l("swapping pool: Spawners, chance: "$chance);
    SwapAllPooled(classes,chance,true,false,true); //Skip anything non-persistent, swap tags
    l("done swapping pool: Spawners");


    ClearClassesList(classes);
    i=0;
    classes[i++]=class'HGame.WizardCardIcon'; //All Wizard Cards
    classes[i++]=class'HGame.Jellybean'; // All loose jelly beans
    classes[i++]=class'HGame.ChocolateFrog';
    classes[i++]=class'HGame.JarFlobberwormMucus';
    classes[i++]=class'HGame.JarWiggentreeBark';
    classes[i++]=class'HGame.FlobberwormMucus';
    classes[i++]=class'HGame.WiggentreeBark';

    ClearSkipActorList();

    chance = GetGlobalFloat("HP2RLooseItemRando");
    l("swapping pool: Loose Items, chance: "$chance);
    SwapAllPooled(classes,chance,true); //Skip anything non-persistent
    l("done swapping pool: Loose Items");
}

function AnyEntry()
{
    local int i;
    local float chance;
    local string c;
    local class<Actor> classes[10];

    Super.FirstEntry();

    ClearClassesList(classes);
    i=0;
    classes[i++]=class'HGame.CauldronSmall';
    classes[i++]=class'HGame.CauldronStudent';
    classes[i++]=class'HGame.CauldronTeacher';
    classes[i++]=class'HGame.BoxSmallWooden';
    classes[i++]=class'HGame.ArmorHelmet';
    classes[i++]=class'HGame.HBooks';
    classes[i++]=class'HGame.HBottlesJars';

    ClearSkipActorList();
    AddSkipActorType(class'RiddlesDiary');
    AddSkipActorType(class'BooksFloorPedestal');
    AddSkipActorType(class'JarBeans');
    AddSkipActorType(class'BooksLargeGroup1'); //This is a bit too big when included in the same pool
    AddSkipActorType(class'BooksOwlBookendBooks'); //This is a bit too big when included in the same pool

    chance = GetGlobalFloat("HP2RKnickKnackRando");
    l("Swapping Knick-Knacks: "$hp2r.localURL);
    l("swapping pool: Knick-Knacks, chance: "$chance);
    SwapAllPooled(classes,chance,false,true); //Only swap non-persistent things
    l("done swapping pool: Knick-Knacks");
}
