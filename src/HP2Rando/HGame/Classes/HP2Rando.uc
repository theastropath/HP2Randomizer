class HP2Rando extends HP2RInfo transient;

var transient #var(PlayerPawn) Player;
var transient string localURL;

var transient HP2RBase modules[48];
var transient int num_modules;

var config string modules_to_load[48];
var config int config_version;
var config int rando_beaten;

var transient bool runPostFirstEntry;
var transient bool bTickEnabled;// bTickEnabled is just for HP2RandoTests to inspect

var int seed, tseed;

var HP2Rando hp2r;

function InitRando()
{
    localURL = Caps(GetURLMap());
    log("InitRando: LocalURL is "$localURL);

    hp2r = self;
    default.hp2r = self; //Singleton reference

    //CrcInit();
    ClearModules();
    //LoadFlagsModule();

    CheckConfig();
    LoadModules();

    RandoEnter();


}

function RandoEnter()
{
    local int i;
    local bool firstTime;

    Enable('Tick');
    bTickEnabled=true;

    firstTime = true; //TODO: Actually figure this out (or is this even appropriate for HP2?)
    //We could spawn in an info object if it doesn't already exist (which would signify first entry)
    //and that object could also track what GameState the game was in last time.  We probably actually
    //want to re-randomize each time the GameState changes.

    //ReEntry is tricky, because non-bPersistent objects will be reset to their original state (at least,
    //in a future version of the engine?).

    //Each module will need to determine whether the objects it modifies are bPersistent or not (or a mix)
    //and figure out how frequently it needs to re-randomize

    if (firstTime == true){
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