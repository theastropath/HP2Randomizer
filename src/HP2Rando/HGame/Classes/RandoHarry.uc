class RandoHarry injects harry
  Config(User); 

var travel int seed;
var HP2Rando hp2r;

function HP2Rando GetHP2R()
{
    if (hp2r != None) return hp2r;
    foreach AllActors(class'HP2Rando',hp2r) return hp2r;

    hp2r = Spawn(class'HP2Rando');

    //hp2r.SetdxInfo(DeusExLevelInfo);
    hp2r.InitRando();
    log("GetHP2R(), hp2r: "$hp2r);
    return hp2r;
}

exec function DumpSeed()
{
    ClientMessage("Harry Seed is "$seed);

    if (hp2r==None){
        ClientMessage("HP2Rando does not exist!!!");
        return;
    }

    ClientMessage("HP2Rando seed is "$hp2r.seed);
    ClientMessage("HP2Rando is "$hp2r);
}

function bool SetGameState (string strNewGameState)
{
    local bool bRet;
    bRet = Super.SetGameState(strNewGameState);

    hp2r.ChangeGameState(strNewGameState);

    return bRet;
}

event TravelPostAccept()
{
    Super.TravelPostAccept();

    log("TravelPostAccept RandoHarry");

    GetHP2R();

    hp2r.PlayerReady();
}

event PreClientTravel()
{
    Super.PreClientTravel();

    hp2r.PreTravel();
}

function RollSeed()
{
    local string seedInput;

    log("RollSeed()");

    if (seed!=-1){
        log("Seed was already set in player to "$seed);
        hp2r.seed = seed;
        hp2r.tseed = seed;
        return;
    }

    seedInput = Rand(MaxInt) @ (FRand()*1000000) @ (Level.TimeSeconds*1000);
    seed = hp2r.Crc( seedInput );
    log("Initial Crc( "$seedInput$" ) = "$seed);
    hp2r.seed = seed;
    hp2r.tseed = seed;
    //bSetSeed = 0;
    seed = hp2r.rng(1000000);
    log("Seed after HP2R.RNG = "$seed);
    hp2r.seed = seed;
    hp2r.tseed = seed;
}


defaultproperties
{
     bAutoCenterCamera=False //Autocentre camera sucks ass
     seed=-1
}
