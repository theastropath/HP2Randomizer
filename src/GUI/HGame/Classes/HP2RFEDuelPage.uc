class HP2RFEDuelPage injects FEDuelPage;

function string GetLocalDuelName (string strId, int Id)
{
    local string dlgString;

    dlgString = Super.GetLocalDuelName(strId,Id);

    if (Id!=10) { //Harry is 10
        dlgString = dlgString$" (LVL "$(10-id)$")";
    }

    return dlgString;
}