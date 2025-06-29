class HP2RFixups extends HP2RActorsBase transient;

//#region PreFirstEntry
function PreFirstEntry()
{
    local CauldronMixing cm;
    local GenericSpawner gs;

    switch(hp2r.localURL){
        case "ENTRYHALL_HUB.UNR":
            //Make sure the mixing cauldron in the potions class stays put
            foreach AllActors(class'CauldronMixing',cm,'EnablePotionMix'){
                cm.bIsSecretGoal=true;
                break;
            }

            //Also make sure the Chest (actually a GenericSpawner) in the potions class
            //stays there, so you will always have the bark and mucous required for the
            //lesson.  I believe opening the chest is also required to proceed, so just
            //having the ingredients isn't good enough.
            foreach AllActors(class'GenericSpawner',gs){
                if (gs.CutName!="Chest") continue;
                gs.bIsSecretGoal=true;
            }
            break;
    }
}
//#endregion

//#region AnyEntry
function AnyEntry()
{
    local Actor a;
    local Mover m;

    switch(hp2r.localURL){
        case "ENTRYHALL_HUB.UNR":
            //Reset the Gryffindor common room chest?  Normally non-persistent.
            break;
        case "TRANSITION.UNR":
            ReplaceTransitionDragonStatues();
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
            //on the lowering platform
            foreach AllActors(class'Actor',a,'4CrabSecretChest'){break;}
            a.SetLocation(vect(512.8884,7.153972,178.3913));
            break;

    }
}
//#endregion

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



function ReplaceTransitionDragonStatues()
{
    local int num;
    local float newYaw, newScale;
    local Mesh newMesh;
    local StatueDragon ds;

    num = rng(24);

    switch(num)
    {
        case 0:
            newMesh = SkeletalMesh'HProps.skStatueDragonMesh';
            newYaw = 0;
            newScale = 3.0;
            break;
        case 1:
            newMesh = SkeletalMesh'HProps.skLockhartSt01Mesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 2:
            newMesh = SkeletalMesh'HProps.skLockhartSt02Mesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 3:
            newMesh = SkeletalMesh'HProps.skLockhartSt03Mesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 4:
            newMesh = SkeletalMesh'HProps.skLockhartSt04Mesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 5:
            newMesh = SkeletalMesh'HProps.skLockhartSt05Mesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 6:
            newMesh = SkeletalMesh'HProps.skLockhartSt06Mesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 7:
            newMesh = SkeletalMesh'HProps.skLockhartSt07Mesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 8:
            newMesh = SkeletalMesh'HProps.skLockhartSt08Mesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 9:
            newMesh = SkeletalMesh'HProps.skArmorWholeSuitMesh';
            newYaw = 0;
            newScale = 3.0;
            break;
        case 10:
            newMesh = SkeletalMesh'HProps.skStatueGregorySmarmyMesh';
            newYaw = 0;
            newScale = 3.0;
            break;
        case 11:
            newMesh = SkeletalMesh'HProps.skStatueHunchbackWitchMesh';
            newYaw = 0;
            newScale = 3.0;
            break;
        case 12:
            newMesh = SkeletalMesh'HProps.skDragonSkeletonMesh';
            newYaw = 16384;
            newScale = 2.2;
            break;
        case 13:
            newMesh = SkeletalMesh'HProps.skSnakeHeadMesh';
            newYaw = 16384;
            newScale = 3.0;
            break;
        case 14:
            newMesh = SkeletalMesh'HProps.skStatueOwlMesh';
            newYaw = -16384;
            newScale = 5.0;
            break;
        case 15:
            newMesh = SkeletalMesh'HProps.skDishesHagridTeaPotMesh';
            newYaw = 0;
            newScale = 17.0;
            break;
        case 16:
            newMesh = SkeletalMesh'HProps.skChristmasTreeMesh';
            newYaw = 0;
            newScale = 1.3;
            break;
        case 17:
            newMesh = SkeletalMesh'HProps.skFordAngliaDamagedMesh';
            newYaw = 8000;
            newScale = 3.5;
            break;
        case 18:
            newMesh = SkeletalMesh'HPModels.skChickenLegMesh';
            newYaw = 0;
            newScale = 20.0;
            break;
        case 19:
            newMesh = SkeletalMesh'HProps.skPlantsBushDragonMesh';
            newYaw = 0;
            newScale = 3.0;
            break;
        case 20:
            newMesh = SkeletalMesh'HProps.skJarBeansMesh';
            newYaw = 0;
            newScale = 12.0;
            break;
        case 21:
            newMesh = SkeletalMesh'HProps.skBarrelMinersMesh';
            newYaw = 0;
            newScale = 2.0;
            break;
        case 22:
            newMesh = SkeletalMesh'HProps.skChallengeStarFinalMesh';
            newYaw = 0;
            newScale = 2.0;
            break;
        case 23:
            newMesh = SkeletalMesh'HProps.skVaseUrnMesh';
            newYaw = 0;
            newScale = 5.5;
            break;
        default:
            l("Invalid Transition Dragon mesh replacement selected! "$num);
            return;
    }

    foreach AllActors(class'StatueDragon', ds){
        ds.Mesh = newMesh;
        ds.DrawScale = newScale;
        ds.DesiredRotation.Yaw = newYaw;
        ds.SetRotation(ds.DesiredRotation);
    }
}
