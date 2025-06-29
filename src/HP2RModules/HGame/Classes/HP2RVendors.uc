class HP2RVendors extends HP2RActorsBase transient;
//I HAVE FLOBBERWORM MUCUS

function PostAnyEntry()
{
    ShuffleVendorItems();
    //Randomize vendor prices?
}

function ShuffleVendorItems()
{
    local float chance;
    local Characters chara, vendors[30];
    local Characters.EVendorDialog vendorDias[30];
    local int numVendors, slot, i;
    local byte val;

    chance = GetGlobalFloat("HP2RVendorsSwap");

    if (chance<=0.0) return;

    numVendors=0;
    foreach AllActors(class'Characters',chara){
        if (chara.CharacterSells==Sells_Nothing) continue; //Shuffle only vendors
        if (chara.bInCurrentGameState==False) continue; //Only shuffle the vendors who are currently present
        if (chara.bPersistent==True) continue; //Only do non-persistent characters
        vendors[numVendors] = chara;

        if (chara.VendorDialogSet!=VDialog_DuelVendor) {
            vendorDias[numVendors] = chara.VendorDialogSet; //Store the original dialog set away
        } else {
            //Figure out an appropriate voice for the former duel vendor 
            //(This *could* randomize between the two generic voices for each)
            if (IsDuellistMale(chara)){
                vendorDias[numVendors] = VDialog_GenericMale1;
            } else {
                vendorDias[numVendors] = VDialog_GenericFemale1;
            }
        }
        numVendors++;

        l("Vendor "$ActorToString(chara)$" selling "$chara.CharacterSells.EnumName(chara.CharacterSells));
    }

    l("HP2RVendors Swapping.  Found "$numVendors$" vendors, shuffling with chance "$chance);

    if (numVendors<=0) return;

    for (i=numVendors-1;i>=0;i--) {
        slot = rng(i+1);
        SwapVendorInfo(vendors[i],vendors[slot]);
    }

    for(i=0;i<numVendors;i++){
        //Set the vendor dialog set before initializing
        if (vendors[i].IsDuelVendor()){
            vendors[i].VendorDialogSet=VDialog_DuelVendor;
        } else {
            vendors[i].VendorDialogSet=vendorDias[i];
        }

        vendors[i].VendorInit(); //Make sure the dialog is set up right for everyone
    }
}

//Yoinked logic (but tightened up) from Duellist::DuellistSex()
function bool IsDuellistMale(Characters c)
{
    switch (c.Mesh){
        case SkeletalMesh'skhp2_genmale1Mesh':
        case SkeletalMesh'skhp2_genmale2Mesh':
        case SkeletalMesh'skDracoMesh':
            return true;
    }
    return false;
}

//Pass *ALL* the vendor info between the characters getting swapped
function SwapVendorInfo(Characters a, Characters b)
{
    local Characters.ESells val;
    local Characters.EVendorDialog dia;
    local int i;
    local TriggerChangeLevel tcl;
    local bool bo, blockPlayers, colActors, blockActors;

    val = a.CharacterSells;
    a.CharacterSells = b.CharacterSells;
    b.CharacterSells = val;

    i = a.nPriceNimbus2001;
    a.nPriceNimbus2001 = b.nPriceNimbus2001;
    b.nPriceNimbus2001 = i;

    i = a.nPriceQArmor;
    a.nPriceQArmor = b.nPriceQArmor;
    b.nPriceQArmor = i;

    i = a.nPriceWBark;
    a.nPriceWBark = b.nPriceWBark;
    b.nPriceWBark = i;

    i = a.nPriceFMucus;
    a.nPriceFMucus = b.nPriceFMucus;
    b.nPriceFMucus = i;

    i = a.nPriceBronzeCardsMin;
    a.nPriceBronzeCardsMin = b.nPriceBronzeCardsMin;
    b.nPriceBronzeCardsMin = i;

    i = a.nPriceBronzeCardsMax;
    a.nPriceBronzeCardsMax = b.nPriceBronzeCardsMax;
    b.nPriceBronzeCardsMax = i;

    i = a.nPriceSilverCardsMin;
    a.nPriceSilverCardsMin = b.nPriceSilverCardsMin;
    b.nPriceSilverCardsMin = i;

    i = a.nPriceSilverCardsMax;
    a.nPriceSilverCardsMax = b.nPriceSilverCardsMax;
    b.nPriceSilverCardsMax = i;

    i = a.nFMucusInventoryMin;
    a.nFMucusInventoryMin = b.nFMucusInventoryMin;
    b.nFMucusInventoryMin = i;

    i = a.nFMucusInventoryMax;
    a.nFMucusInventoryMax = b.nFMucusInventoryMax;
    b.nFMucusInventoryMax = i;

    i = a.nWBarkInventoryMin;
    a.nWBarkInventoryMin = b.nWBarkInventoryMin;
    b.nWBarkInventoryMin = i;

    i = a.nWBarkInventoryMax;
    a.nWBarkInventoryMax = b.nWBarkInventoryMax;
    b.nWBarkInventoryMax = i;

    i = a.DuelRank;
    a.DuelRank = b.DuelRank;
    b.DuelRank = i;

    i = a.DuelBeans;
    a.DuelBeans = b.DuelBeans;
    b.DuelBeans = i;

    tcl = a.DuelLevelTrigger;
    a.DuelLevelTrigger = b.DuelLevelTrigger;
    b.DuelLevelTrigger = tcl;

    //Duel Vendors don't do luring, so make sure that gets traded as well
    bo = a.bLuringEnabled;
    a.bLuringEnabled = b.bLuringEnabled;
    b.bLuringEnabled = bo;

    i = a.nLureDistance;
    a.nLureDistance = b.nLureDistance;
    b.nLureDistance = i;

    //The duellists become "in GameState", but bHidden when your duel level is too low.
    //We'll keep them in the pool, but swap their bHidden'ness with them as their
    //Duel selling gets passed around.  This should keep the vendors from getting
    //reshuffled each time you unlock a new Duel vendor.
    //Duel vendors also default to bBlockActors, bBlockPlayers, and bCollideActors false
    //so swap those as well
    bo = a.bHidden;
    a.bHidden = b.bHidden;
    b.bHidden = bo;

    //swap bBlockActors (const)
    //swap bBlockPlayers (const)
    //swap bCollideActors (const)
    colActors = a.bCollideActors;
    blockActors = a.bBlockActors;
    blockPlayers = a.bBlockPlayers;
    a.SetCollision(b.bCollideActors, b.bBlockActors, b.bBlockPlayers);
    b.SetCollision(colActors,blockActors,blockPlayers);
}