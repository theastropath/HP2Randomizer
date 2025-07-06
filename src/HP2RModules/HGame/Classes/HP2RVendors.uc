class HP2RVendors extends HP2RActorsBase transient;
//I HAVE FLOBBERWORM MUCUS

function CheckConfig()
{
    InitRandoFlag("HP2RVendorsSwap","100");
    InitRandoFlag("HP2RVendorPriceMin","0.5");
    InitRandoFlag("HP2RVendorPriceMax","1.5");
    InitRandoFlag("HP2RDuelPrizeMin","0.5");
    InitRandoFlag("HP2RDuelPrizeMax","2.0");
    InitRandoFlag("HP2RVendorExtraLocs","1");
}


function PostAnyEntry()
{
    ShuffleVendorItems();
    RandomizePrices();
}

function bool IsValidVendor(Characters c)
{
    if (PlaceholderVendor(c)!=None)      return true; //Placeholder Vendor is always valid
    if (c.CharacterSells==Sells_Nothing) return false; //Only vendors
    if (c.bInCurrentGameState==False)    return false; //Only do the vendors who are currently present
    if (c.bPersistent==True)             return false; //Only do non-persistent characters

    return true;
}

//Mostly to consistently ensure the price doesn't end up as zero
function int MultPrice(int price, float mult)
{
    local int endPrice;

    endPrice = price * mult;

    if (endPrice <= 0){
        endPrice = 1;
    }

    return endPrice;
}

function RandomizePrices()
{
    local float priceMin, priceMax, duelMin, duelMax; //Settings
    local float priceMult, duelMult;
    local Characters c;

    priceMin = GetGlobalFloat("HP2RVendorPriceMin");
    priceMax = GetGlobalFloat("HP2RVendorPriceMax");
    duelMin  = GetGlobalFloat("HP2RDuelPrizeMin");
    duelMax  = GetGlobalFloat("HP2RDuelPrizeMax");

    foreach AllActors(class'Characters',c){
        if (!IsValidVendor(c)) continue;

        priceMult = rngrange(1,priceMin,priceMax);
        duelMult  = rngrange(1,duelMin,duelMax);

        //Normal selling things
        c.nPriceNimbus2001     = MultPrice(c.nPriceNimbus2001,priceMult);
        c.nPriceQArmor         = MultPrice(c.nPriceQArmor,priceMult);
        c.nPriceWBark          = MultPrice(c.nPriceWBark,priceMult);
        c.nPriceFMucus         = MultPrice(c.nPriceFMucus,priceMult);
        c.nPriceBronzeCardsMin = MultPrice(c.nPriceBronzeCardsMin,priceMult);
        c.nPriceBronzeCardsMax = MultPrice(c.nPriceBronzeCardsMax,priceMult);
        c.nPriceSilverCardsMin = MultPrice(c.nPriceSilverCardsMin,priceMult);
        c.nPriceSilverCardsMax = MultPrice(c.nPriceSilverCardsMax,priceMult);

        //Duel prize
        c.DuelBeans = MultPrice(c.DuelBeans,duelMult);
    }

}

function CreateVendorPlaceholders()
{
    if (GetGlobalBool("HP2RVendorExtraLocs")==False) return;

    switch(hp2r.localURL){
        case "ENTRYHALL_HUB":
            Spawn(class'PlaceholderVendor',,, vect(580,-555,-275), rot(0,-16384,0));     //Window across from Duel Vendors
            Spawn(class'PlaceholderVendor',,, vect(-1100,-700,-275), rot(0,-8000,0));    //Corner near front door
            Spawn(class'PlaceholderVendor',,, vect(880,-1780,-20), rot(0,-22000,0));     //Stairwell near Gryffindor Common Room
            Spawn(class'PlaceholderVendor',,, vect(700,-2920,107), rot(0,16384,0));      //Near Skurge door
            Spawn(class'PlaceholderVendor',,, vect(-600,-2630,235), rot(0,-20000,0));    //Near Grand Staircase door
            Spawn(class'PlaceholderVendor',,, vect(140,-1515,-20), rot(0,22000,0));      //Near Rictusempra door
            Spawn(class'PlaceholderVendor',,, vect(530,-2460,110), rot(0,40000,0));      //Staircase outside Gryff common room stairs
            Spawn(class'PlaceholderVendor',,, vect(-245,-2927,237), rot(0,16384,0));     //Hallway near grand staircase door
            Spawn(class'PlaceholderVendor',,, vect(-2440,-1160,-465), rot(0,0,0));       //Bottom of stairs to dungeon
            Spawn(class'PlaceholderVendor',,, vect(-4190,-1785,-465), rot(0,8000,0));    //Main dungeon hall
            Spawn(class'PlaceholderVendor',,, vect(-2515,-1975,-595), rot(0,-16384,0));  //Opposite Slytherin common room door
            Spawn(class'PlaceholderVendor',,, vect(1460,-385,-275), rot(0,-16384,0));    //Great Hall
            Spawn(class'PlaceholderVendor',,, vect(2725,-1300,-275), rot(0,16384,0));    //Great Hall
            break;
        case "GRANDSTAIRCASE_HUB":
            Spawn(class'PlaceholderVendor',,, vect(-320,-5890,430), rot(0,22000,0));     //Bottom floor, near staircase
            Spawn(class'PlaceholderVendor',,, vect(-2072,-5255,945), rot(0,-16384,0));   //Near Wizard Card Challenge Room door
            Spawn(class'PlaceholderVendor',,, vect(-128,-6895,1200), rot(0,16384,0));    //Fourth floor hallway
            Spawn(class'PlaceholderVendor',,, vect(-2145,-6375,1455), rot(0,-16384,0));  //Fifth floor, near Headmaster entrance
            Spawn(class'PlaceholderVendor',,, vect(185,-4655,1710), rot(0,0,0));         //Infirmary
            Spawn(class'PlaceholderVendor',,, vect(-125,-2435,1340), rot(0,-16384,0));   //Infirmary office
            break;
        case "GROUNDS_HUB":
            Spawn(class'PlaceholderVendor',,, vect(1500,-2250,175), rot(0,22000,0));   //Upper level near castle wall
            Spawn(class'PlaceholderVendor',,, vect(-590,-585,-115), rot(0,-22000,0));   //Lower hill near Diffindo door
            Spawn(class'PlaceholderVendor',,, vect(-90,0,80), rot(0,32768,0));   //Next to dragon statue
            Spawn(class'PlaceholderVendor',,, vect(250,-720,45), rot(0,32768,0));   //Between main doors and dragon statue
            Spawn(class'PlaceholderVendor',,, vect(-2480,-220,45), rot(0,0,0));   //Near Greenhouse
            Spawn(class'PlaceholderVendor',,, vect(2345,3140,-190), rot(0,-16384,0));   //Hagrid's Hut
            break;
    }
}

function RemoveVendorPlaceholders()
{
    local PlaceholderVendor pv;

    foreach AllActors(class'PlaceholderVendor',pv){
        pv.Destroy();
    }
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

    CreateVendorPlaceholders();

    numVendors=0;
    foreach AllActors(class'Characters',chara){
        if (!IsValidVendor(chara)) continue;
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

        //Reset the beans
        if (vendors[i].VendorJellybean!=None){
            vendors[i].VendorJellybean.Destroy();
        }
        vendors[i].GotoState('VendorIdle');
    }

    RemoveVendorPlaceholders();
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
    local PlaceholderVendor pvA, pvB;
    local bool bo, blockPlayers, colActors, blockActors;

    pvA=PlaceholderVendor(a);
    pvB=PlaceholderVendor(b);

    if (pvA!=None && pvB!=None){
        //both are placeholders, just leave them where they are
        return;
    } else if ((pvA!=None && pvB==None) || (pvA==None && pvB!=None)){
        //One is a placeholder, physically swap them
        Swap(a,b);

        //Move the WeaponLoc's to be where the character is.  I guess
        //that doesn't get updated unless you're near the person?
        if (pvA==None){
            a.WeaponLoc = a.Location;
        }
        if (pvB==None){
            b.WeaponLoc = b.Location;
        }
        return;
    }
    //Neither is a placeholder, swap their properties

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