class RandoHarry injects harry
  Config(User); 

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
    if (hp2r==None){
        ClientMessage("HP2Rando does not exist!!!");
        return;
    }

    ClientMessage("HP2Rando seed is "$hp2r.seed);
    ClientMessage("HP2Rando is "$hp2r);
    ClientMessage("Global String seed is "$GetGlobalInt("HP2RSeed"));
}

exec function DumpLevelName()
{
    ClientMessage("Current Level is "$Level.LevelEnterText);
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

    hp2r = None;
}

defaultproperties
{
     bAutoCenterCamera=False //Autocentre camera sucks ass
}
