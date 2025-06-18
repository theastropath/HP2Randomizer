class HP2RBase extends HP2RInfo abstract;

var transient HP2Rando hp2r;
var transient float overallchances;

var transient bool inited;

simulated function PreFirstEntry();
simulated function FirstEntry();
simulated function PostFirstEntry();

simulated function AnyEntry();
simulated function PostAnyEntry();

simulated function ReEntry(bool IsTravel);

static function class<HP2RBase> GetModuleToLoad(HP2Rando hp2r, class<HP2RBase> request)
{
    return request;
}

function Init(HP2Rando thp2r)
{
    //l(Self$".Init()");
    hp2r = thp2r;
    if(!inited) {
        CheckConfig();
    }
    inited = true;
}

simulated function HP2Rando GetHP2R()
{
    return hp2r;
}

static function HP2RBase Find(optional bool bSilent)
{
    if(class'HP2Rando'.default.hp2r == None) return None;
    return class'HP2Rando'.default.hp2r.FindModule(default.class, bSilent);
}