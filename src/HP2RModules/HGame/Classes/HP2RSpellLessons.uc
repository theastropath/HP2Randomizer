class HP2RSpellLessons extends HP2RActorsBase transient;

const NO_ARROW = 4;

function CheckConfig()
{
    InitRandoFlag("HP2RSpellArrowDirMode","PatternChaos");
    InitRandoFlag("HP2RSpellWandSpeedMin","0.75");
    InitRandoFlag("HP2RSpellWandSpeedMax","1.50");
}

//#region AnyEntry
function AnyEntry()
{
    local SpellLessonTrigger slt;
    local float min,max;

    SetSeed( "HP2RSpellLessons ArrowDirections" );
    RandomizeSpellLessonArrows();

    SetSeed( "HP2RSpellLessons WandSpeed" );
    min = GetGlobalFloat("HP2RSpellWandSpeedMin");
    max = GetGlobalFloat("HP2RSpellWandSpeedMax");
    RandomizeSpellLessonWandSpeed(min,max);
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

/*
/////////////////INITIAL ARROW PATTERNS///////////////
                 For Reference Purposes

Rictusempra
=============
-LLUURL-LLUURL-LLUURL-LLUURL---
LLUURL  LLUURL  LLUURL  LLUURL
31 SLIP's


Skurge
=======
--L-R-LRU-U--L-RLRUU---L-RL-R-U-U--L-R-L-R-U-U---
LRLRUU   LRLRUU  LRLRUU  LRLRUU
49 SLIP's


Diffindo
=========
--U-DU-U-RR--UD-UU-RR-U-DU-U-R-R-
UDUURR  UDUURR  UDUURR
33 SLIP's


Spongify
=========
---U-R-R-U-D-D-R----U-R-R-U-D-D-R----U-R-R-U-D-D-R-----
URRUDDR   URRUDDR   URRUDDR
55 SLIP's

//////////////////////////////////////////////////////
*/


//Randomize all spell lessons with the same method (is this actually how it should be?)
function RandomizeSpellLessonArrows()
{
    local string mode;

    mode = GetGlobalString("HP2RSpellArrowDirMode");

    l("RandomizeSpellLessonArrows: "$mode);

    switch(mode){
        case "ExistingChaos":
            //Each existing arrow gets a completely randomly selected arrow direction
            ExistingArrowsChaosRando();
            break;
        case "FullChaos":
            //Randomize *all* slots, including currently empty ones, to any arrow type, including None
            FullArrowChaosRando();
            break;
        case "ConsistentArrows":
            //Randomize each arrow direction to a new direction (so all Up become Left, for example)
            ExistingArrowsConsistentRando();
            break;
        case "PatternChaos":
            //Normally the game repeats a pattern multiple times.  Generate a new (equally long) pattern
            //and repeat that the same number of times. Pattern carries through each round, increasing 
            //in length like in vanilla.
            ExistingArrowsChaosPatternRando();
            break;
        case "Vanilla":
            //Don't randomize the arrows at all
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

function DumpSLIPArrows(SpellLessonInterpolationPoint start, SpellLessonInterpolationPoint end)
{
    local SpellLessonInterpolationPoint slipStart, slipEnd, slip;
    local string pattern[3];
    local int i;

    pattern[0]="";
    pattern[1]="";
    pattern[2]="";

    for(slip=start;
        slip!=end && slip!=None;
        slip=SpellLessonInterpolationPoint(slip.Next))
    {
        for(i=0;i<ArrayCount(pattern);i++){
            switch(slip.DirectionArrow[i]){
                case Arrow_Up:
                    pattern[i] = pattern[i]$"U";
                    break;
                case Arrow_Down:
                    pattern[i] = pattern[i]$"D";
                    break;
                case Arrow_Left:
                    pattern[i] = pattern[i]$"L";
                    break;
                case Arrow_Right:
                    pattern[i] = pattern[i]$"R";
                    break;
                case Arrow_None:
                    pattern[i] = pattern[i]$"-";
                    break;
                default:
                    pattern[i] = pattern[i]$" ?";
                    break;
            }
        }
    }

    for(i=0;i<ArrayCount(pattern);i++){
        l("Pattern["$i$"] = "$pattern[i]);
    }

}

function int GetPatternLengthFromSpellShape(SpellLessonTrigger.ELessonShape shape)
{
    switch(shape){
        case LessonShape_Rictusempra:
        case LessonShape_Skurge:
        case LessonShape_Diffindo:
            return 6;
        case LessonShape_Spongify:
            return 7; //Annoying
    }
    err("Unknown Spell Lesson shape! "$shape);
    return 6; //Just assume it's similar to most others?
}

//Pure randomization of the existing pattern, then repeat that pattern, like in vanilla
//Pattern carries through each round
function ExistingArrowsChaosPatternRando()
{
    local SpellLessonInterpolationPoint slipStart, slipEnd, slip;
    local SpellLessonTrigger slt;
    local int ArrowPattern[10];
    local string pattern;
    local int i, patternLength, pattProg;

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
        
        l("Before rando: ");
        DumpSLIPArrows(slipStart,slipEnd);

        patternLength = GetPatternLengthFromSpellShape(slt.LessonShape);
        //initialize the pattern array
        for(i=0;i<ArrayCount(ArrowPattern);i++){
            ArrowPattern[i]=NO_ARROW;
        }

        //Figure out the pattern based on difficulty 3
        pattProg=0;
        for(slip=slipStart;
            slip!=slipEnd && slip!=None;
            slip=SpellLessonInterpolationPoint(slip.Next))
        {
            //l("SLIP "$slip.Position$" Arrow direction "$slip.DirectionArrow[2].EnumName(slip.DirectionArrow[2]));
            if (slip.DirectionArrow[2]==Arrow_None){
                continue; //Skip it
            }
            ArrowPattern[pattProg++] = slip.DirectionArrow[2];

            if (pattProg==patternLength) break;
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
        for(i=0;i<ArrayCount(ArrowPattern) && ArrowPattern[i]!=NO_ARROW;i++){
            ArrowPattern[i]=rng(4); //Any direction, just not NONE
        }

        //Log the randomized pattern
        pattern = "Randomized "$slt.LessonShape.EnumName(slt.LessonShape)$" Pattern: ";
        for(i=0;i<ArrayCount(ArrowPattern) && ArrowPattern[i]!=NO_ARROW;i++){
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
        pattProg=0;
        for(slip=slipStart;
            slip!=slipEnd && slip!=None;
            slip=SpellLessonInterpolationPoint(slip.Next))
        {
            if (slip.DirectionArrow[2]==Arrow_None) continue;

            slip.DirectionArrow[2] = EDirectionArrow(ArrowPattern[pattProg++]);
            //l("SLIP "$slip.Position$" New Arrow direction "$slip.DirectionArrow[2].EnumName(slip.DirectionArrow[2]));

            //Copy the pattern down to the easier levels
            if (slip.DirectionArrow[0] != Arrow_None) slip.DirectionArrow[0] = slip.DirectionArrow[2];
            if (slip.DirectionArrow[1] != Arrow_None) slip.DirectionArrow[1] = slip.DirectionArrow[2];

            if (pattProg>=patternLength) pattProg=0; //Loop back to the start of the pattern
        }

        l("After rando: ");
        DumpSLIPArrows(slipStart,slipEnd);
        l(" ");

    }
}

//#endregion
