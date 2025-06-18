class HP2RandoGameInfo extends GameInfo;

var HP2Rando hp2r;

function HP2Rando GetHP2R()
{
    if (hp2r != None) return hp2r;
    foreach AllActors(class'HP2Rando',hp2r) return hp2r;

    hp2r = Spawn(class'HP2Rando');

    //hp2r.SetdxInfo(DeusExLevelInfo);
    hp2r.InitRando();
    log("GetHP2R(), hp2r: "$hp2r, self.name);
    return hp2r;
}

event InitGame( string Options, out string Error )
{
    Super.InitGame(Options,Error);

    log("InitGame HP2RandoGameInfo", self.name);

    GetHP2R();
}