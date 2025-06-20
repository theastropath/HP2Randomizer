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



simulated function int SetSeed(coerce string name)
{
    local int oldseed;
    oldseed = hp2r.SetSeed( hp2r.Crc(hp2r.seed $ hp2r.localURL $ name) );
    hp2r.rngraw();// advance the rng
    return oldseed;
}

simulated function int SetGlobalSeed(coerce string name)
{
    local int oldseed;
    oldseed = hp2r.SetSeed( hp2r.seed + hp2r.Crc(name) );
    hp2r.rngraw();// advance the rng
    return oldseed;
}

simulated function int BranchSeed(coerce string name)
{
    local int oldseed;
    oldseed = hp2r.SetSeed( hp2r.Crc(hp2r.seed $ name $ hp2r.tseed) );
    hp2r.rngraw();// advance the rng
    return oldseed;
}

simulated function int ReapplySeed(int oldSeed)
{
    return hp2r.SetSeed(oldSeed);
}

simulated function int rng(int max)
{
    local float f;
    // divide by 1 less than 0xFFFFFF, so that it's never the max and we don't have to worry about rounding
    f = float(hp2r.rngraw())/16777214.0;
    f *= float(max);
    return int(f);
}

simulated function bool rngb()
{
    return hp2r.rng(100) < 50;
}

simulated function float rngf()
{// 0 to 1.0 inclusive
    local float f;
    f = float(hp2r.rngraw())/16777215.0;// 0xFFFFFF because rngraw does a right shift by 8 bits
    //l("rngf() "$f);
    return f;
}

simulated function float rngfn()
{// -1.0 to 1.0
    return rngf() * 2.0 - 1.0;
}

simulated function float rngfn_min_dist(float min_dist)
{// -1.0 to 1.0, adding a minimum distance away from 0
    local float f;
    f = rngfn();
    if(f >= 0.0) return f + min_dist;
    else return f - min_dist;
}

simulated function float rngrange(float val, float min, float max)
{
    local float mult, r, ret;
    mult = max - min;
    r = rngf();
    ret = val * (r * mult + min);
    //l("rngrange r: "$r$", mult: "$mult$", min: "$min$", max: "$max$", val: "$val$", return: "$ret);
    return ret;
}

simulated function float rngrecip(float val, float max)
{
    local float f;
    f = rngrange(1, 1, max);
    if( rngb() ) {
        f = 1 / f;
    }
    return val * f;
}

simulated function float rngrangeseeded(float val, float min, float max, coerce string classname)
{
    local float mult, r, ret;
    local int oldseed;
    oldseed = SetGlobalSeed(classname);
    mult = max - min;
    r = rngf();
    ret = val * (r * mult + min);
    //l("rngrange r: "$r$", mult: "$mult$", min: "$min$", max: "$max$", val: "$val$", return: "$ret);
    ReapplySeed(oldseed);
    return ret;
}

simulated function float rngexp(float origmin, float origmax, float curve)
{
    local float frange, f, min, max;
    min = origmin;
    max = origmax;
    if(min != 0)
        min = min ** (1/curve);
    max = (max+1.0) ** (1/curve);
    frange = max-min;
    f = rngf()*frange + min;
    f = f ** curve;
    f = FClamp( f, origmin, origmax );
    return f;
}

simulated function bool chance_single(float percent)
{
    return rngf()*100.0 < percent;
}
