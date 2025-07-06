class HP2RJellybean injects Jellybean;

function PreBeginPlay()
{
    local Characters c;

    c = Characters(Owner);
    if (  !bInitialized && c!=None && c.CharacterSells!=Sells_Nothing)
    {
        //Make it so the Jellybeans that vendors toss around are always
        //a consistent colour, based on what they're selling
        bInitialized = True;
        switch (c.CharacterSells){
            case Sells_Nimbus2001:
                iSkinTexture=9; //skGreenPurpleCheckerBeanTex0
                break;
            case Sells_QArmor:
                iSkinTexture=11; //skRedBlackStripeBeanTex0
                break;
            case Sells_WBark:
                iSkinTexture=12; //skBeanBrownTex0
                break;
            case Sells_FMucus:
                iSkinTexture=7; //skBlueJellyBeanTex0
                break;
            case Sells_BronzeCards:
                iSkinTexture=15; //skBeanOrngeTex0
                break;
            case Sells_SilverCards:
                iSkinTexture=1; //skJellybeanTex0
                break;
            case Sells_Duel:
                iSkinTexture=10; //skSpottedJellyBeanTex0,  this won't show up, DuelVendors don't have beans
                break;
            case Sells_Nothing:
                iSkinTexture=6; //skBeanBogieTex0, we should never see this
                break;
        }
    }

    Super.PreBeginPlay();
}