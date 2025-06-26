class HP2RFEInGamePage injects FEInGamePage;

function Paint (Canvas Canvas, float X, float Y)
{
    local float fScaleFactor;

    Super.Paint(Canvas,X,Y);

    fScaleFactor = Canvas.SizeX / WinWidth;

    //Draw some version information
    PaintRandoVersionInfo(Canvas,fScaleFactor);
}

//Add some randomizer information to the menu
function PaintRandoVersionInfo (Canvas Canvas, float fScaleFactor)
{
    local harry PlayerHarry;
    local HP2Rando hp2r;
    local Font fontText;
    local Color colorText;
    local string s;
    local int ControlLeft, ControlY;

    PlayerHarry = harry(Root.Console.Viewport.Actor);
    hp2r = PlayerHarry.hp2r;

    if ( Canvas.SizeX <= 512 )
    {
        fontText = baseConsole(PlayerHarry.Player.Console).LocalSmallFont;
    } 
    else 
    {
        fontText = baseConsole(PlayerHarry.Player.Console).LocalMedFont;
    }
    colorText.R = 255;
    colorText.G = 255;
    colorText.B = 255;

    ControlLeft = 15;
    ControlY    = 100;

    ///////////////////////////////////////////
    //   Actually draw the information now   //
    ///////////////////////////////////////////

    s="HP2 Randomizer"@hp2r.VersionString();
    DrawRandoText(Canvas, ControlLeft, ControlY, s, fontText, colorText);
    
    ControlY+=15;
    s="Seed:"@hp2r.seed;
    DrawRandoText(Canvas, ControlLeft, ControlY, s, fontText, colorText);
}

function DrawRandoText(Canvas canvas, float x, float y, string text, Font fontText, Color col)
{
    local float W;
    local float H;
    local Font saveFont;

    saveFont = Canvas.Font;
    Canvas.Font = fontText;
    Canvas.DrawColor = col;
    TextSize(Canvas,text,W,H);
    Root.SetPosScaled(Canvas,x,y);
    Canvas.DrawText(text);
    Canvas.Font = saveFont;
}