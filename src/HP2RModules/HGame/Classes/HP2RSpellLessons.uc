class HP2RSpellLessons extends HP2RActorsBase transient;

function AnyEntry()
{
    local SpellLessonInterpolationPoint slip;
    local int i;

    SetSeed( "HP2RSpellLessons" );

    foreach AllActors(class'SpellLessonInterpolationPoint',slip){
        for(i=0;i<ArrayCount(slip.DirectionArrow);i++){
            if (slip.DirectionArrow[i]==Arrow_None) continue;

            //As a starting point, we'll just do a pure randomization of the existing arrows
            slip.DirectionArrow[i] = EDirectionArrow(rng(4));

            //Additional ways this could be randomized
            // - Randomize *all* slots, including currently empty ones, to any arrow type, including None
            // - Randomize each arrow direction to a new direction (so all Up become Left, for example)
            // - Pure randomization of the existing pattern, then repeat that pattern, like in vanilla
            
            //TODO: Make these different methods selectable

            //TODO: Randomize the speed of the wand?  The SpellLessonTrigger sets the wand speed based on
            //the fWandSpeed value and the difficulty.
        }
    }
}