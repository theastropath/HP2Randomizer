class HP2RSpellLessons extends HP2RActorsBase transient;

//#region AnyEntry
function AnyEntry()
{
    local SpellLessonTrigger slt;
    local float f;

    SetSeed( "HP2RSpellLessons ArrowDirections" );
    RandomizeSpellLessonArrows(3); //TODO: use a config option to select which randomization mode

    SetSeed( "HP2RSpellLessons WandSpeed" );
    RandomizeSpellLessonWandSpeed(0.75,1.5);//TODO: Make this rando range configurable
}
//#endregion

//#region Wand Speed
//Randomize the speed of the wand.  The SpellLessonTrigger sets the wand speed based on
//the fWandSpeed value and the difficulty.
//As a point of reference, fWandSpeed of 60 is outrageously fast
//Rictusempra defaults to 35.
function RandomizeSpellLessonWandSpeed(float min, float max)
{
    local SpellLessonTrigger slt;
    local float f;

    foreach AllActors(class'SpellLessonTrigger',slt){
        f = slt.fWandSpeed;
        slt.fWandSpeed = rngrange(slt.fWandSpeed,min,max);
        l("SpellLessonTrigger Shape: "$slt.LessonShape.EnumName(slt.LessonShape)$" wand speed was "$f$" now is "$slt.fWandSpeed);
    }
}
//#endregion

//#region Arrow Rando
//Randomize all spell lessons with the same method (is this actually how it should be?)
function RandomizeSpellLessonArrows(int mode)
{
    switch(mode){
        case 0:
            //Each existing arrow gets a completely randomly selected arrow direction
            ExistingArrowsChaosRando();
            break;
        case 1:
            //Randomize *all* slots, including currently empty ones, to any arrow type, including None
            FullArrowChaosRando();
            break;
        case 2:
            //Randomize each arrow direction to a new direction (so all Up become Left, for example)
            ExistingArrowsConsistentRando();
            break;
        case 3:
            //Normally the game repeats a pattern multiple times.  Generate a new (equally long) pattern
            //and repeat that the same number of times. Pattern carries through each round, increasing 
            //in length like in vanilla.
            ExistingArrowsChaosPatternRando();
            break;
        default:
            l("Unknown Spell Lesson Arrow Randomization mode "$mode);
            break;
    }
}

//Any arrows that currently exist get a randomly selected direction
function ExistingArrowsChaosRando()
{
    local SpellLessonInterpolationPoint slip;
    local int i;

    foreach AllActors(class'SpellLessonInterpolationPoint',slip){
        for(i=0;i<ArrayCount(slip.DirectionArrow);i++){
            if (slip.DirectionArrow[i]==Arrow_None) continue;

            slip.DirectionArrow[i] = EDirectionArrow(rng(4)); //Any direction, just not NONE
        }
    }
}

//Randomize literally every slot
//But needs to skip the first and last slots, because it gets hard (and first and last overlap
//on Rictusempra).  Luckily, the SpellLessonTrigger contains a reference to both the start
//and the end!
function FullArrowChaosRando()
{
    local SpellLessonInterpolationPoint slip;
    local SpellLessonTrigger slt;
    local int i;

    //Randomize all the slots
    foreach AllActors(class'SpellLessonInterpolationPoint',slip){
        for(i=0;i<ArrayCount(slip.DirectionArrow);i++){
            slip.DirectionArrow[i] = EDirectionArrow(rng(5)); //Any direction or NONE
        }
    }

    //Clear the first and last slots so that you aren't instantly bombarded with an arrow
    foreach AllActors(class'SpellLessonTrigger',slt){
        slip = SpellLessonInterpolationPoint(slt.GetLessonActor(class'SpellLessonInterpolationPoint',slt.nameIPStart));
        if (slip!=None){
            for(i=0;i<ArrayCount(slip.DirectionArrow);i++){
                slip.DirectionArrow[i]=Arrow_None;
            }
        }

        slip = SpellLessonInterpolationPoint(slt.GetLessonActor(class'SpellLessonInterpolationPoint',slt.nameIPEnd));
        if (slip!=None){
            for(i=0;i<ArrayCount(slip.DirectionArrow);i++){
                slip.DirectionArrow[i]=Arrow_None;
            }
        }
    }
}

//Each existing arrow becomes a new direction, with all of the arrows in a
//specific direction becoming the same new direction
function ExistingArrowsConsistentRando()
{
    local SpellLessonInterpolationPoint slip;
    local int i,j, spare;
    local int dirs[4];

    dirs[0] = 0;
    dirs[1] = 1;
    dirs[2] = 2;
    dirs[3] = 3;

    //Randomize the directions!
    for(i=0;i<ArrayCount(dirs);i++){
        j = rng(ArrayCount(dirs));
        spare = dirs[i];
        dirs[i] = dirs[j];
        dirs[j] = spare;
    }

    foreach AllActors(class'SpellLessonInterpolationPoint',slip){
        for(i=0;i<ArrayCount(slip.DirectionArrow);i++){
            if (slip.DirectionArrow[i]==Arrow_None) continue;

            //Swap the arrows to the newly determined directions
            slip.DirectionArrow[i] = EDirectionArrow(dirs[slip.DirectionArrow[i]]);
        }
    }

}

//Pure randomization of the existing pattern, then repeat that pattern, like in vanilla
//Pattern carries through each round
function ExistingArrowsChaosPatternRando()
{
    local SpellLessonInterpolationPoint slipStart, slipEnd, slip;
    local SpellLessonTrigger slt;
    local int ArrowPattern[10];
    local bool patternStarted;
    local string pattern;
    local int i;

    foreach AllActors(class'SpellLessonTrigger',slt)
    {
        l("ExistingArrowsChaosPatternRando Shape: "$slt.LessonShape.EnumName(slt.LessonShape));
        slipStart = SpellLessonInterpolationPoint(slt.GetLessonActor(class'SpellLessonInterpolationPoint',slt.nameIPStart));
        slipEnd = SpellLessonInterpolationPoint(slt.GetLessonActor(class'SpellLessonInterpolationPoint',slt.nameIPEnd));
        if (slipStart==None){
            l("Couldn't find starting point!");
            continue;
        }
        if (slipEnd==None){
            l("Couldn't find end point!");
            continue;
        }

        //initialize the pattern array
        for(i=0;i<ArrayCount(ArrowPattern);i++){
            ArrowPattern[i]=4; //Arrow_None = 4
        }

        //Figure out the pattern based on difficulty 3
        i=0;
        patternStarted = false;
        for(slip=slipStart;
            slip!=slipEnd && slip!=None;
            slip=SpellLessonInterpolationPoint(slip.Next))
        {
            //l("SLIP "$slip.Position$" Arrow direction "$slip.DirectionArrow[2].EnumName(slip.DirectionArrow[2]));
            if (slip.DirectionArrow[2]==Arrow_None){
                if (patternStarted){
                    break; //We've hit the end of the pattern, break out of here
                } else {
                    continue; //Keep going until we find the start of the pattern
                }
            }
            patternStarted = true;
            ArrowPattern[i++] = slip.DirectionArrow[2];
        }

        //Log the initial pattern
        pattern = "Initial "$slt.LessonShape.EnumName(slt.LessonShape)$" Pattern: ";
        for(i=0;i<ArrayCount(ArrowPattern) && ArrowPattern[i]!=4;i++){
            switch(ArrowPattern[i]){
                case 0:
                    pattern = pattern$" Up";
                    break;
                case 1:
                    pattern = pattern$" Down";
                    break;
                case 2:
                    pattern = pattern$" Left";
                    break;
                case 3:
                    pattern = pattern$" Right";
                    break;
                default:
                    pattern = pattern$" ???";
                    break;
            }
        }
        l(pattern);

        //Randomize the arrows in the pattern...
        for(i=0;i<ArrayCount(ArrowPattern) && ArrowPattern[i]!=4;i++){ // 4 = Arrow_None
            ArrowPattern[i]=rng(4); //Any direction, just not NONE
        }

        //Log the randomized pattern
        pattern = "Randomized "$slt.LessonShape.EnumName(slt.LessonShape)$" Pattern: ";
        for(i=0;i<ArrayCount(ArrowPattern) && ArrowPattern[i]!=4;i++){
            switch(ArrowPattern[i]){
                case 0:
                    pattern = pattern$" Up";
                    break;
                case 1:
                    pattern = pattern$" Down";
                    break;
                case 2:
                    pattern = pattern$" Left";
                    break;
                case 3:
                    pattern = pattern$" Right";
                    break;
                default:
                    pattern = pattern$" ???";
                    break;
            }
        }
        l(pattern);

        //Copy the new random pattern into the SLIPs
        i=0;
        patternStarted=false;
        for(slip=slipStart;
            slip!=slipEnd && slip!=None;
            slip=SpellLessonInterpolationPoint(slip.Next))
        {
            if (slip.DirectionArrow[2]==Arrow_None){
                if (patternStarted){
                    i=0;
                    patternStarted=false;
                    continue; //We've hit the end of the pattern, reset and keep going
                } else {
                    continue; //Keep going until we find the start of the pattern
                }
            }
            patternStarted = true;

            slip.DirectionArrow[2] = EDirectionArrow(ArrowPattern[i++]);
            //l("SLIP "$slip.Position$" New Arrow direction "$slip.DirectionArrow[2].EnumName(slip.DirectionArrow[2]));

            //Copy the pattern down to the easier levels
            if (slip.DirectionArrow[0] != Arrow_None) slip.DirectionArrow[0] = slip.DirectionArrow[2];
            if (slip.DirectionArrow[1] != Arrow_None) slip.DirectionArrow[1] = slip.DirectionArrow[2];
        }
    }
}

//#endregion
