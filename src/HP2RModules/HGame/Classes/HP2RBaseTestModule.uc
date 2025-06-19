class HP2RBaseTestModule extends HP2RBase;

simulated function PreFirstEntry()
{
    Super.PreFirstEntry();
    l("PreFirstEntry");
    l("RNG(100) = "$rng(100));
    l("RNG(100) = "$rng(100));
    l("RNG(100) = "$rng(100));
    l("RNG(100) = "$rng(100));
    l("RNG(100) = "$rng(100));
}

simulated function FirstEntry()
{
    Super.FirstEntry();
    l("FirstEntry");

}

simulated function PostFirstEntry()
{
    Super.PostFirstEntry();
    l("PostFirstEntry");

}

simulated function AnyEntry()
{
    Super.AnyEntry();
    l("AnyEntry");

}

simulated function PostAnyEntry()
{
    Super.PostAnyEntry();
    l("PostAnyEntry");

}

simulated function ReEntry(bool IsTravel)
{
    Super.ReEntry(IsTravel);
    l("ReEntry "$IsTravel);

}