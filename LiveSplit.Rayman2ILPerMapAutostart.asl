state("Rayman2")
{
    string8 levelID      : "Rayman2.exe", 0x10039F;
    float posX           : "Rayman2.exe", 0x100578, 0x4, 0x0, 0x1C;
    float posY           : "Rayman2.exe", 0x100578, 0x4, 0x0, 0x20;
    byte finalBossHealth : "Rayman2.exe", 0x102D64, 0xE4, 0x0, 0x4, 0x741;
    bool isLoading       : "Rayman2.exe", 0x11663C;
	byte engineMode      : "Rayman2.exe", 0x100380;
}

init
{
   vars.scanForBossHealth = false;
   vars.inMenu = false;
}

update
{
    if (!vars.scanForBossHealth && current.levelID.ToLower() == "rhop_10" && current.finalBossHealth == 24)
        vars.scanForBossHealth = true;
		
	if (current.levelID.ToLower() == "menu")
		vars.inMenu = true;

	
    //print("levelID: " + current.levelID);
    //print("posX: " + current.posX);
    //print("posY: " + current.posY);
    //print("finalbossHealth: " + current.finalBossHealth);
    //print("scanForBossHealth: " + vars.scanForBossHealth);
}

start
{
    if (current.levelID.ToLower() == "jail_20" && old.levelID.ToLower() == "jail_20" && !old.isLoading &&
        (Math.Abs(current.posX - old.posX) > 0.1 ||
        (Math.Abs(current.posY - old.posY) > 0.1)))
        return true; // X/Y position changed
		
	if (old.engineMode == 5 && current.engineMode == 9)
		return true;
	
}

reset
{
    return current.levelID.ToLower() == "jail_10" &&
        old.levelID.ToLower() != "jail_10";
}

isLoading
{
    return current.isLoading;
}

split
{

	Func<string, bool> isIgnoredMap = delegate(string mapName) {
		string n = mapName.ToLower();
		return (n ==  "menu" || n == "bast_09" || n=="batam_10" || n=="batam_20" || n=="nego_10" || n=="poloc_10" || n=="poloc_20" || n=="poloc_30" || n=="poloc_40");
	};
	
	string newLvl = current.levelID.ToLower();
	string oldLvl = old.levelID.ToLower();

    if (newLvl != oldLvl && // Changed map,
		newLvl != "raycap" && // Didn't go to raycap
		newLvl != "bonux" && // Didn't go to raycap
		oldLvl != "mapmonde" && // Didn't come from the overworld,
		oldLvl != "ball" && // Ball is the only cutscene in between regular maps
		newLvl != "ly_10" && // Don't split when going into Walk of Life
		newLvl != "ly_20" && // Don't split when going into Walk of Power
	!isIgnoredMap(current.levelID) && !isIgnoredMap(old.levelID)) {
        return true; // level changed
	}
	
    if (vars.scanForBossHealth && current.levelID.ToLower() == "rhop_10" && current.finalBossHealth == 0)
    {
        vars.scanForBossHealth = false;
        return true; // final boss health 0
    }
    return false;
}
