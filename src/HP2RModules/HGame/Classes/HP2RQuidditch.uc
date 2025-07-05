class HP2RQuidditch extends HP2RActorsBase transient;

function CheckConfig()
{
    //Bludger things:
    InitRandoFlag("HP2RQuidBludgerDmgMin","0.5");
    InitRandoFlag("HP2RQuidBludgerDmgMax","2.5");
    InitRandoFlag("HP2RQuidBludgerSpeedMin","1.0");
    InitRandoFlag("HP2RQuidBludgerSpeedMax","3.0");
    InitRandoFlag("HP2RQuidBludgerRangeMin","1.0");
    InitRandoFlag("HP2RQuidBludgerRangeMax","3.0");
    InitRandoFlag("HP2RQuidBludgerPursueTimeMin","1.5");
    InitRandoFlag("HP2RQuidBludgerPursueTimeMax","5.0");

    //Seeker things:
    InitRandoFlag("HP2RQuidSeekerRecoveryMin","0.9");
    InitRandoFlag("HP2RQuidSeekerRecoveryMax","3.0");
    InitRandoFlag("HP2RQuidSeekerPenaltyMin","0.5");
    InitRandoFlag("HP2RQuidSeekerPenaltyMax","2.0");
    InitRandoFlag("HP2RQuidSeekerKickItvlMin","0.25");
    InitRandoFlag("HP2RQuidSeekerKickItvlMax","1.5");
    InitRandoFlag("HP2RQuidSeekerDmgMin","0.75");
    InitRandoFlag("HP2RQuidSeekerDmgMax","2.0");

}

function bool IsQuidditchMap()
{
    switch (hp2r.localURL){
        case "QUIDDITCH_INTRO": //This probably doesn't need to be randomized at the moment, but just in case there's anything visual?
        case "QUIDDITCH":
            return true;
    }
    return false;
}

function AnyEntry()
{

    Super.AnyEntry();

    if (!IsQuidditchMap()) return; //No quidditch to randomize

    RandomizeBludger();

}

function PostAnyEntry()
{
    Super.PostAnyEntry();

    if (!IsQuidditchMap()) return; //No quidditch to randomize

    RandomizeSeeker();
    //Randomize player speed?
    //Randomize snitch jerkiness?
}

function RandomizeBludger()
{
    local Bludger b;
    local float f,fmin,fmax;
    local int imin,imax;

    SetSeed( "HP2RQuidditch Bludger Match"$hp2r.Player.curQuidMatchNum );

    foreach AllActors(class'Bludger',b){
        //Note that this means each bludger will have individual stats

        fmin = GetGlobalFloat("HP2RQuidBludgerDmgMin");
        fmax = GetGlobalFloat("HP2RQuidBludgerDmgMax");
        b.Damage = rngrange(b.Damage,fmin,fmax); //Default 10

        fmin = GetGlobalFloat("HP2RQuidBludgerSpeedMin");
        fmax = GetGlobalFloat("HP2RQuidBludgerSpeedMax");
        b.fLaunchSpeed = rngrange(b.fLaunchSpeed,fmin,fmax); //Default 700.0

        fmin = GetGlobalFloat("HP2RQuidBludgerRangeMin");
        fmax = GetGlobalFloat("HP2RQuidBludgerRangeMax");
        f = rngrange(1.0,fmin,fmax);
        b.fLaunchProximity = b.fLaunchProximity * f; //Default 1200.0
        b.fPursuitAbortDistance = b.fPursuitAbortDistance * f; //Default 1300.0

        fmin = GetGlobalFloat("HP2RQuidBludgerPursueTimeMin");
        fmax = GetGlobalFloat("HP2RQuidBludgerPursueTimeMax");
        b.fPursuitTimeLimit = rngrange(b.fPursuitTimeLimit,fmin,fmax); //Default 4.0

        l("Bludger "$b$":  Damage: "$b.Damage$
                        "  fLaunchSpeed: "$b.fLaunchSpeed$
                        "  fLaunchProximity: "$b.fLaunchProximity$
                        "  fPursuitAbortDistance: "$b.fPursuitAbortDistance$
                        "  fPursuitTimeLimit: "$b.fPursuitTimeLimit);
    }
}

//This needs to run after the QuidditchDirector has set the stats on the seeker
function RandomizeSeeker()
{
    local float f,fmin,fmax;
    local Seeker s;

    SetSeed( "HP2RQuidditch Seeker Match"$hp2r.Player.curQuidMatchNum );

    foreach AllActors(class'Seeker',s){
        fmin = GetGlobalFloat("HP2RQuidSeekerRecoveryMin");
        fmax = GetGlobalFloat("HP2RQuidSeekerRecoveryMax");
        f = rngrange(1.0,fmin,fmax);
        s.HealthRecoveryRate = s.HealthRecoveryRate * f;
        s.HealthRecoveryRateWhenStunned = s.HealthRecoveryRateWhenStunned * f;

        fmin = GetGlobalFloat("HP2RQuidSeekerPenaltyMin");
        fmax = GetGlobalFloat("HP2RQuidSeekerPenaltyMax");
        f = rngrange(1.0,fmin,fmax);
        s.fKickedPenalty = s.fKickedPenalty * f;
        s.fBumpedPenalty = s.fBumpedPenalty * f;

        fmin = GetGlobalFloat("HP2RQuidSeekerKickItvlMin");
        fmax = GetGlobalFloat("HP2RQuidSeekerKickItvlMax");
        f = rngrange(1.0,fmin,fmax);
        s.fKickIntervalMin = s.fKickIntervalMin * f;
        s.fKickIntervalMax = s.fKickIntervalMax * f;

        fmin = GetGlobalFloat("HP2RQuidSeekerDmgMin");
        fmax = GetGlobalFloat("HP2RQuidSeekerDmgMax");
        s.KickDamage = rngrange(s.KickDamage,fmin,fmax);

        l( "Seeker "$s$":  HealthRecoveryRate: "$s.HealthRecoveryRate$
                        "  HealthRecoveryRateWhenStunned: "$s.HealthRecoveryRateWhenStunned$
                        "  fKickedPenalty: "$s.fKickedPenalty$
                        "  fBumpedPenalty: "$s.fBumpedPenalty$
                        "  fKickIntervalMin: "$s.fKickIntervalMin$
                        "  fKickIntervalMax: "$s.fKickIntervalMax$
                        "  KickDamage: "$s.KickDamage);

    }
}
