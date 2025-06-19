class HP2RInfo extends HP2RVersion config(HP2Rando) abstract;

var transient int passes;
var transient int fails;
var config int config_version;

simulated function class<Actor> GetClassFromString(string classstring, class<Actor> c, optional bool silent)
{
    local class<Actor> a;

    if( InStr(classstring, ".") == -1 ) {
        classstring = "HGame." $ classstring;
    }
    a = class<Actor>(DynamicLoadObject(classstring, class'class'));
    if( a == None ) {
        if (!silent){
            err("GetClassFromString: failed to load class "$classstring);
        }
    }
    else if( ClassIsChildOf(a, c) == false ) {
        if (!silent){
            err("GetClassFromString: " $ classstring $ " is not a subclass of " $ c.name);
        }
        return None;
    }
    //l("GetClassFromString: found " $ classstring);
    return a;
}

function bool ConfigOlderThan(int major, int minor, int patch, int build)
{
    return VersionOlderThan(config_version, major, minor, patch, build);
}

function CheckConfig()
{
    if( config_version < VersionNumber() ) {
        info("upgraded config from "$config_version$" to "$VersionNumber());
        config_version = VersionNumber();
        SaveConfig();
    }
}

simulated function HP2Rando GetHP2R()
{
    local HP2Rando hp2r;
    foreach AllActors(class'HP2Rando', hp2r) {
        return hp2r;
    }
    return None;
}

simulated final function #var(PlayerPawn) player(optional bool quiet)
{
    local #var(PlayerPawn) p;
    local HP2Rando hp2r;

    hp2r = GetHP2R();
    if(hp2r != None) p = hp2r.Player;
    if( p == None ) {
        foreach AllActors(class'#var(PlayerPawn)', p){break;}
        if(hp2r != None) hp2r.Player = p;
    }
    if( p == None && !quiet ) warning("player() found None");
    return p;
}

static function int Ceil(float f)
{
    local int ret;
    ret = f;
    if( float(ret) < f )
        ret++;
    return ret;
}

static function int imod(int a, int b)
{// % converts to float in UnrealScript
    return a-(a/b*b);
}

/*
========= LOGGING FUNCTIONS
*/
simulated function debug(coerce string message)
{
#ifdef debug
    if(Len(message)>900)
        warning("Len(message)>900: "$Left(message, 500));
    else
        log(message, class.name);
#endif
}

//does not send to telemetry
simulated function l(coerce string message)
{
    if(Len(message)>900)
        warning("Len(message)>900: "$Left(message, 500));
    else
        log(message, class.name);

    /*if( (InStr(VersionString(), "Alpha")>=0 || InStr(VersionString(), "Beta")>=0) ) {
        class'Telemetry'.static.SendLog(Self, "DEBUG", message);
    }*/
}

simulated function info(coerce string message)
{
    if(Len(message)>900)
        warning("Len(message)>900: "$Left(message, 500));
    else
        log("INFO: " $ message, class.name);
    //class'DXRTelemetry'.static.SendLog(GetDXR(), Self, "INFO", message);
}

simulated function warning(coerce string message)
{
    if(Len(message)>900)
        warning("Len(message)>900: "$Left(message, 500));
    else
        log("WARNING: " $ message, class.name);
    //class'DXRTelemetry'.static.SendLog(GetDXR(), Self, "WARNING", message);
}

simulated function err(coerce string message, optional bool skip_player_message)
{
    if(Len(message)>900)
        err("Len(message)>900: "$Left(message, 500));
    else
        log("ERROR: " $ message, class.name);
#ifdef singleplayer
    if(!skip_player_message && player() != None) {
        player().ClientMessage( Class @ message, 'ERROR', true );
    }
#else
    BroadcastMessage(class.name$": ERROR: "$message, true, 'ERROR');
#endif

    //class'DXRTelemetry'.static.SendLog(GetDXR(), Self, "ERROR", message);
}

defaultproperties
{
    bPersistent=True //Make sure things stick around if we want them to (ie. aren't transient)
}
