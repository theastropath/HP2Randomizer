class HP2Rando extends HP2RInfo transient;

var transient #var(PlayerPawn) Player;
var transient string localURL;

var transient HP2RBase modules[48];
var transient int num_modules;

var config string modules_to_load[48];
var config int config_version;
var config int rando_beaten;

var transient bool runPostFirstEntry, runPostAnyEntry;
var transient bool bTickEnabled;// bTickEnabled is just for HP2RandoTests to inspect

var int seed, tseed;
var transient private int CrcTable[256]; // for string hashing to do more stable seeding

var HP2Rando hp2r;

function InitRando()
{
    localURL = Caps(GetURLMap());
    log("InitRando: LocalURL is "$localURL);

    hp2r = self;
    default.hp2r = self; //Singleton reference

    CrcInit();

    foreach AllActors(class'#var(PlayerPawn)', player){break;}

    ClearModules();
    //LoadFlagsModule();

    CheckConfig();
    LoadModules();

}

function PlayerReady()
{
    player.RollSeed();
    l("HP2R InitRando - seed: "$seed$"  tseed: "$tseed);

    RandoEnter();
}

function HP2RMapRandoInfo GetMapRandoInfo()
{
    local HP2RMapRandoInfo mapRando;
    foreach AllActors(class'HP2RMapRandoInfo',mapRando){break;}
    return mapRando;
}

function RandoEnter()
{
    local int i;
    local bool firstTime;
    local HP2RMapRandoInfo mapRando;

    Enable('Tick');
    bTickEnabled=true;

    mapRando = GetMapRandoInfo();

    firstTime = (mapRando==None);
    //We could spawn in an info object if it doesn't already exist (which would signify first entry)
    //and that object could also track what GameState the game was in last time.  We probably actually
    //want to re-randomize each time the GameState changes.

    if (firstTime){
        mapRando = Spawn(class'HP2RMapRandoInfo');
    }

    //ReEntry is tricky, because non-bPersistent objects will be reset to their original state (at least,
    //in a future version of the engine?).

    //Each module will need to determine whether the objects it modifies are bPersistent or not (or a mix)
    //and figure out how frequently it needs to re-randomize

    SetSeed( Crc(seed $ localURL @ firstTime) );
    if (firstTime == true){
        info("randomizing "$localURL$" using seed " $ seed);
        for(i=0; i<num_modules; i++) {
            modules[i].PreFirstEntry();
        }

        for(i=0; i<num_modules; i++) {
            modules[i].FirstEntry();
        }

        runPostFirstEntry = true;
        info("done randomizing "$localURL$" using seed " $ seed);
    } else {
        for(i=0; i<num_modules; i++) {
            modules[i].ReEntry(true);
        }
    }

    SetSeed( Crc(seed $ localURL $ " AnyEntry") );
    for(i=0; i<num_modules; i++) {
        modules[i].AnyEntry();
    }
}

simulated function PreTravel()
{
    log("PreTravel()");

    default.hp2r = None; //Clear the singleton reference
    Disable('Tick');
    bTickEnabled=false;
    SetTimer(0, false);
}


simulated event Destroyed()
{
    log("HP2Rando being Destroyed!");
    if(default.hp2r == self) {
        default.hp2r = None;// clear the singleton reference
    }
}

function CheckConfig()
{
    local int i;

    l("HP2Rando CheckConfig");

    if( VersionOlderThan(config_version, 1,0,0,0) ) {
        for(i=0; i < ArrayCount(modules_to_load); i++) {
            modules_to_load[i] = "";
        }

        if(#defined(vanilla)){
            l("CheckConfig, vanilla detected");
            vanilla_modules();
        } else {
            warning("unknown mod, using default set of modules!");
            vanilla_modules();
        }
    }
    Super.CheckConfig();
}

function vanilla_modules()
{
    local int i;
    l("Loading vanilla modules");
    modules_to_load[i++] = "HP2RBaseTestModule";
    //modules_to_load[i++] = "DXRMissions";
}


function HP2RBase LoadModule(class<HP2RBase> moduleclass, optional bool forcenew)
{
    local HP2RBase m;
    moduleclass = moduleclass.static.GetModuleToLoad(self, moduleclass);
    l("loading module "$moduleclass);

    if(!forcenew) {
        m = FindModule(moduleclass, true);
        if( m != None ) {
            info("found already loaded module "$m);
            if(m.hp2r != Self) m.Init(Self);
            return m;
        }
    }

    m = Spawn(moduleclass, None);
    if ( m == None ) {
        err("failed to load module "$moduleclass);
        return None;
    }
    modules[num_modules] = m;
    num_modules++;
    m.Init(Self);
    l("finished loading module "$m);
    return m;
}

function HP2RBase LoadModuleByString(string classstring)
{
    local class<Actor> c;
    if( InStr(classstring, ".") == -1 ) {
        classstring = "#var(package)." $ classstring;
    }
    c = GetClassFromString(classstring, class'HP2RBase');
    return LoadModule( class<HP2RBase>(c) );
}

function LoadModules()
{
    local int i;

    for( i=0; i < ArrayCount( modules_to_load ); i++ ) {
        if( modules_to_load[i] == "" ) continue;
        LoadModuleByString(modules_to_load[i]);
    }

    //telemetry = DXRTelemetry(FindModule(class'DXRTelemetry'));
}

simulated event Tick(float deltaTime)
{
    HP2RTick(deltaTime);
}

function HP2RTick(float deltaTime)
{
    local HP2RMapRandoInfo mapRando;
    local int i;

    if(runPostFirstEntry)
    {
        SetSeed( Crc(seed $ localURL $ " PostFirstEntry") );
        for(i=0; i<num_modules; i++) {
            modules[i].PostFirstEntry();
        }
        info("done randomizing "$localURL$" PostFirstEntry using seed " $ seed $ ", deltaTime: " $ deltaTime);
        runPostFirstEntry = false;
    }
    else
    {
        SetSeed( Crc(seed $ localURL $ " PostAnyEntry") );
        for(i=0; i<num_modules; i++) {
            modules[i].PostAnyEntry();
        }

        Disable('Tick');
        bTickEnabled = false;
    }
}

simulated final function HP2RBase FindModule(class<HP2RBase> moduleclass, optional bool bSilent)
{
    local HP2RBase m;
    local int i;
    for(i=0; i<num_modules; i++)
        if( modules[i] != None )
            if( ClassIsChildOf(modules[i].Class, moduleclass) )
                return modules[i];

    foreach AllActors(class'HP2RBase', m)
    {
        if( ClassIsChildOf(m.Class, moduleclass) ) {
            if(!bSilent)
                l("FindModule("$moduleclass$") found "$m);
            modules[num_modules] = m;
            num_modules++;
            m.Init(Self);
            return m;
        }
    }

    if(!bSilent)
        l("didn't find module "$moduleclass);
    return None;
}

function ClearModules()
{
    num_modules=0;
    //flags=None;
}



simulated final function int SetSeed(int s)
{
    local int oldseed;
    oldseed = tseed;
    //log("SetSeed old seed == "$newseed$", new seed == "$s);
    tseed = s;
    return oldseed;
}

const gen1 = 1073741821;// half of gen2, rounded down
const gen2 = 2147483643;
simulated final function int rng(int max)
{
    tseed = gen1 * tseed * 5 + gen2 + (tseed/5) * 3;
    // in unrealscript >>> is right shift and filling the left with 0s, >> shifts but keeps the sign
    // this means we don't need abs, which is a float function anyways
    return imod((tseed >>> 8), max);
}

simulated final function int rngraw()
{
    tseed = gen1 * tseed * 5 + gen2 + (tseed/5) * 3;
    // in unrealscript >>> is right shift and filling the left with 0s, >> shifts but keeps the sign
    // this means we don't need abs, which is a float function anyways
    return (tseed >>> 8);
}


// ============================================================================
// CrcInit https://web.archive.org/web/20181105143221/http://unrealtexture.com/Unreal/Downloads/3DEditing/UnrealEd/Tutorials/unrealwiki-offline/crc32.html
//
// Initializes CrcTable and prepares it for use with Crc.
// ============================================================================

simulated final function CrcInit() {

    const CrcPolynomial = 0xedb88320;

    local int CrcValue;
    local int IndexBit;
    local int IndexEntry;

    for (IndexEntry = 0; IndexEntry < 256; IndexEntry++) {
        CrcValue = IndexEntry;

        for (IndexBit = 8; IndexBit > 0; IndexBit--)
        {
            if ((CrcValue & 1) != 0)
                CrcValue = (CrcValue >>> 1) ^ CrcPolynomial;
            else
                CrcValue = CrcValue >>> 1;
        }

        CrcTable[IndexEntry] = CrcValue;
    }
}


// ============================================================================
// Crc
//
// Calculates and returns a checksum of the given string. Call CrcInit before.
// ============================================================================

simulated final function int Crc(coerce string Text) {

    local int CrcValue;
    local int IndexChar;

    //if(CrcTable[1] == 0)
        //err("CrcTable uninitialized?");

    CrcValue = 0xffffffff;

    for (IndexChar = 0; IndexChar < Len(Text); IndexChar++)
        CrcValue = (CrcValue >>> 8) ^ CrcTable[Asc(Mid(Text, IndexChar, 1)) ^ (CrcValue & 0xff)];

    return CrcValue;
}
