class HP2RVendorManager injects VendorManager;

const fVENDORBAR_DUELLVL_X= 220.0;
const fVENDORBAR_DUELLVL_Y= 74.0;

function DrawVendorBar (Canvas canvas)
{
    local Font fontSave;
    local float fScaleFactor;
    local string strDuelLevel;
    local Color colorText;
    local Color colorTextShadow;
    local StatusItem siJellybeans;
    local float fXTextLen;
    local float fYTextLen;
	local float fBarX;
	local float fBarY;

    Super.DrawVendorBar(canvas);

    //Show the Duelist level (If it's a duel vendor)
    if (Vendor.IsDuelVendor()){
        fontSave = Canvas.Font;
        fScaleFactor = Canvas.GetHudScaleFactor();
        HScale = Class'M212HScale'.Static.CanvasGetHeightScale(Canvas);

        fBarX = GetVendorBarX(Canvas); //+ Offset;
        fBarY = GetVendorBarY(Canvas) * HScale;

        //Get this just to find fonts and colours
        siJellybeans 	= harry(Level.PlayerHarryActor).managerStatus.GetStatusItem(Class'StatusGroupStars',Class'StatusItemStars');
        Canvas.Font 	= siJellybeans.GetCountFont(Canvas);
        colorText 		= siJellybeans.GetCountColor();
        colorTextShadow = siJellybeans.GetCountColor(True);

        //Actually draw the duel level
        strDuelLevel = "LVL "$Vendor.DuelRank;
        Canvas.TextSize(strDuelLevel, fXTextLen, fYTextLen);
        Canvas.SetPos(fBarX + (fVENDORBAR_DUELLVL_X * fScaleFactor * HScale) - fXTextLen / 2, fBarY + (fVENDORBAR_DUELLVL_Y * fScaleFactor * HScale) - fYTextLen / 2);
        Canvas.DrawShadowText(strDuelLevel, colorText, colorTextShadow);

        Canvas.Font = fontSave;
    }
}