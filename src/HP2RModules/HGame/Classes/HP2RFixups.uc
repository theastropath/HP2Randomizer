class HP2RFixups extends HP2RActorsBase transient;

function PreFirstEntry()
{
    local CauldronMixing cm;

    switch(hp2r.localURL){
        case "ENTRYHALL_HUB.UNR":
            //Make sure the mixing cauldron in the potions class stays put
            foreach AllActors(class'CauldronMixing',cm,'EnablePotionMix'){
                cm.bIsSecretGoal=true;
                break;
            }
            break;
    }
}

function AnyEntry()
{
    local Actor a;
    local Mover m;

    switch(hp2r.localURL){
        case "ENTRYHALL_HUB.UNR":
            //Reset the Gryffindor common room chest?  Normally non-persistent.
            break;
        case "BEANREWARDROOM.UNR":
        case "CH2SKURGE.UNR":
        case "CH3DIFFINDO.UNR":
        case "CH4SPONGIFY.UNR":
        case "CH6WIZARDCARD.UNR":
        case "CH7GRYFFINDOR.UNR":
            ResetChallenge();
            break;
        case "CH1RICTUSEMPRA.UNR":
            ResetChallenge();

            //Make sure to move the chest (or whatever) back into place
            foreach AllActors(class'Actor',a,'4CrabSecretChest'){break;}
            a.SetLocation(vect(512.8884,7.153972,178.3913));
            break;

    }
}

function ResetChallenge()
{
    l("ResetChallenge "$hp2r.localURL);
    ResetAllChests();
    ResetAllCauldrons();
}

function ResetAllCauldrons()
{
    local bronzecauldron cauld;

    foreach AllActors(class'bronzecauldron',cauld){
        cauld.Reset();
    }
}

function ResetAllChests()
{
    local chestbronze chest;

    foreach AllActors(class'chestbronze',chest){
        chest.Reset();
    }
}
