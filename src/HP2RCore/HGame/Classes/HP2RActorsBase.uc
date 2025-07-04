class HP2RActorsBase extends HP2RBase abstract;

var class<Actor> _skipactor_types[10];

struct LocationNormal {
    var vector loc;
    var vector norm;
};

struct FMinMax {
    var float min;
    var float max;
};

struct safe_rule {
    var name item_name;
    var string package_name;
    var vector min_pos;
    var vector max_pos;
    var bool allow;
};

function CheckConfig()
{
    local int i;

    i=0;
    _skipactor_types[i++] = class'InvisibleSpawn';
    _skipactor_types[i++] = class'RiddlesDiary';
    _skipactor_types[i++] = class'JarBeans';

    Super.CheckConfig();
}

function AddSkipActorType(class<Actor> skip)
{
    local int i;
    for (i=0;i<ArrayCount(_skipactor_types);i++)
    {
        if (_skipactor_types[i]!=None) continue;
        _skipactor_types[i]=skip;
        return;
    }
}

function ClearSkipActorList()
{
    local int i;
    for (i=0;i<ArrayCount(_skipactor_types);i++)
    {
        _skipactor_types[i]=None;
    }
}

function SwapAll(string classname, float percent_chance, optional bool skipNonPersistent, optional bool skipPersistent)
{
    local Class<Actor> classes[10];

    classes[0] = GetClassFromString(classname, class'Actor');

    SwapAllPooled(classes,percent_chance,skipNonPersistent,skipPersistent);
}

function bool IsActorListedClass(Actor a, class<Actor> classes[10])
{
    local int i;

    if (a==None) return false;

    for (i=0;i<ArrayCount(classes);i++){
        if (classes[i]==None) continue;
        if (ClassIsChildOf(a.class, classes[i])) return true;
    }

    return false;
}

function ClearClassesList(out class<Actor> classes[10])
{
    local int i;
    for (i=0;i<ArrayCount(classes);i++){
        classes[i]=None;
    }
}

//Swap all the items in a list of actor classes in a single pool
function SwapAllPooled(class<Actor> classes[10], float percent_chance, optional bool skipNonPersistent, optional bool skipPersistent, optional bool swapTag, optional bool swapEvent)
{
    local string seedStr;
    local Actor temp[4096];
    local Actor a, b;
    local int num, i, slot;

    seedStr = "SwapAllPooled";
    for(i=0;i<ArrayCount(classes);i++){
        if (classes[i]==None) continue;
        seedStr = seedStr $ " " $ classes[i];
    }

    SetSeed( seedStr );
    num=0;
    foreach AllActors(class'Actor', a)
    {
        if( !IsActorListedClass(a,classes) ) continue;
        if( SkipActor(a) ) continue;
        if (skipNonPersistent && !a.bPersistent) continue;
        if (skipPersistent && a.bPersistent) continue;
        temp[num++] = a;
    }

    if(num<2) {
        l("SwapAllPooled(" $ seedStr $ ", " $ percent_chance $ ") only found " $ num);
        return;
    }

    for(i=num-1; i>=0; i--) { // Fisher-Yates shuffle the array before swapping the actor locations (swapping actor locations can fail, shuffling the array cannot fail, Fisher-Yates works better for unfailable shuffles)
        slot = rng(i+1);
        a = temp[i];
        temp[i] = temp[slot];
        temp[slot] = a;
    }

    for(i=0; i<num; i++) {
        if( percent_chance<100 && !chance_single(percent_chance) ) continue;
        slot=rng(num-1);// -1 because we skip ourself
        if(slot >= i) slot++;
        Swap(temp[i], temp[slot], swapTag, swapEvent);
    }

}


function bool Swap(Actor a, Actor b, optional bool swapTag, optional bool swapEvent)
{
    local vector newloc, oldloc, aloc, bloc;
    local Vector HitLocation, HitNormal;
    local rotator newrot;
    local bool asuccess, bsuccess;
    local Actor abase, bbase, HitActor;
    local bool AbCollideActors, AbBlockActors, AbBlockPlayers;
    local bool BbCollideActors, BbBlockActors, BbBlockPlayers;
    local EPhysics aphysics, bphysics;
    local name atag, btag, aevent,bevent;
    local Characters cA, cB;

    if( a == b ) return true;

    l("swapping "$ActorToString(a)$" and "$ActorToString(b)$" distance == " $ VSize(a.Location - b.Location) );

    cA = Characters(a);
    cB = Characters(b);

    AbCollideActors = a.bCollideActors;
    AbBlockActors = a.bBlockActors;
    AbBlockPlayers = a.bBlockPlayers;

    BbCollideActors = b.bCollideActors;
    BbBlockActors = b.bBlockActors;
    BbBlockPlayers = b.bBlockPlayers;

    oldloc = a.Location;
    newloc = b.Location;

    a.SetCollision(false, false, false);
    b.SetCollision(false, false, false);
    bloc = oldloc + (b.CollisionHeight - a.CollisionHeight) * vect(0,0,1);
    bsuccess = SetActorLocation(b, bloc );
    a.SetCollision(AbCollideActors, AbBlockActors, AbBlockPlayers);
    b.SetCollision(BbCollideActors, BbBlockActors, BbBlockPlayers);
    if( bsuccess == false ) {
        warning("bsuccess failed to move " $ ActorToString(b) $ " into location of " $ ActorToString(a) );
        return false;
    } else {
        //Move succeeded, but was kind of far from where it should be
        if (VSize(bloc - b.Location)>5){
            HitActor=Trace(HitLocation,HitNormal,b.Location,bloc,False);
            if (HitActor!=None){
                //There's a wall or something between the locations, this new location shouldn't have succeeded
                //Move it back to the original location and give up
                warning("Should have moved to "$bloc$" but ended up at "$b.Location$" instead (distance="$VSize(bloc - b.Location)$")");
                SetActorLocation(b, newloc);
                warning("bsuccess moved " $ ActorToString(b) $ " into location of " $ ActorToString(a) $ ", but was moved out of line of sight of intended location ("$HitActor$" in the way)");
                return False;
            }
        }
    }
    a.SetCollision(false, false, false);
    b.SetCollision(false, false, false);
    aloc = newloc + (a.CollisionHeight - b.CollisionHeight) * vect(0,0,1);
    asuccess = SetActorLocation(a, aloc);
    a.SetCollision(AbCollideActors, AbBlockActors, AbBlockPlayers);
    b.SetCollision(BbCollideActors, BbBlockActors, BbBlockPlayers);
    if( asuccess == false ) {
        warning("asuccess failed to move " $ ActorToString(a) $ " into location of " $ ActorToString(b) );
        SetActorLocation(b, newloc);
        return false;
    } else if (VSize(aloc - a.Location)>5) {
        //Move succeeded, but was kind of far from where it should be
        HitActor=Trace(HitLocation,HitNormal,a.Location,aloc,False);
        if (HitActor!=None){
            //There's a wall or something between the locations, this new location shouldn't have succeeded
            //Move it back to the original location and give up
            warning("Should have moved to "$aloc$" but ended up at "$a.Location$" instead (distance="$VSize(aloc - a.Location)$")");
            SetActorLocation(a, oldloc);
            SetActorLocation(b, newloc);
            warning("asuccess moved " $ ActorToString(a) $ " into location of " $ ActorToString(b) $ ", but was moved out of line of sight of intended location ("$HitActor$" in the way)");
            return False;
        }
    }

    newrot = b.Rotation;
    b.DesiredRotation = a.Rotation; //So many things in HP2 are set to bRotateToDesired, so just copy that across as well
    b.SetRotation(a.Rotation);
    a.DesiredRotation = newrot;
    a.SetRotation(newrot);

    //Characters set rSave in PostBeginPlay.  After finishing a vendor conversation,
    //they return to rotation rSave.  Update rSave to match their new rotation.
    if (cA!=None){
        cA.rSave = cA.Rotation;
    }
    if (cB!=None){
        cB.rSave = cB.Rotation;
    }

    aphysics = a.Physics;
    bphysics = b.Physics;
    abase = a.Base;
    bbase = b.Base;

    a.SetPhysics(bphysics);
    if(abase != bbase) a.SetBase(bbase);
    b.SetPhysics(aphysics);
    if(abase != bbase) b.SetBase(abase);

    if (swapTag){
        atag=a.Tag;
        btag=b.Tag;
        
        a.Tag = btag;
        b.Tag = atag;
    }

    if (swapEvent){
        aevent=a.Event;
        bevent=b.Event;
        
        a.Event = bevent;
        b.Event = aevent;
    }

    return true;
}

function bool SkipActorBase(Actor a)
{
    if( a.Owner != None || a.bStatic || a.bHidden || a.bMovable==False || a.bIsSecretGoal || a.bDeleteMe )
        return true;
    return false;
}

function bool SkipActor(Actor a)
{
    local int i;
    if( SkipActorBase(a) ) {
        return true;
    }
    for(i=0; i < ArrayCount(_skipactor_types); i++) {
        if(_skipactor_types[i] == None) break;
        if( a.IsA(_skipactor_types[i].name) ) return true;
    }
    return false;
}

function bool SetActorLocation(Actor a, vector newloc)
{
    if( ! a.SetLocation2(newloc) ) {
        return false;
    }

    return true;
}

