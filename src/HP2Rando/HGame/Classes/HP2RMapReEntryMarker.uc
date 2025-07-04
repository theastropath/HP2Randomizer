//This basically exists to differentiate between a map load and a savegame load, 
//where non-persistent items may have been reset (map load) or maintained (savegame load)
class HP2RMapReEntryMarker extends info;

defaultproperties
{
    bPersistent=False
}
