class RandoHarry injects harry
  Config(User); 

exec function RandoTest()
{
    ClientMessage("Success!  Code has been injected!");
}

event PreClientTravel()
{
    local HP2Rando hp2r;

    Super.PreClientTravel();

    hp2r = class'HP2Rando'.default.hp2r;
    hp2r.PreTravel();
}

defaultproperties
{
     bAutoCenterCamera=False
}