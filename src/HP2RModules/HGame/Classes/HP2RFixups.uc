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