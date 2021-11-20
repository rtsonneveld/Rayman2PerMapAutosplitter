state("Rayman2")
{
    string8 levelID      : "Rayman2.exe", 0x10039F;
    float posX           : "Rayman2.exe", 0x100578, 0x4, 0x0, 0x1C;
    float posY           : "Rayman2.exe", 0x100578, 0x4, 0x0, 0x20;
    float posZ           : "Rayman2.exe", 0x100578, 0x4, 0x0, 0x24;
    //bool dsgVar16        : "Rayman2.exe", 0x100578, 0x4, 0xC, 0x0, 0xC, 0x0, 0x10, 0xB54;
    uint customBits       : "Rayman2.exe", 0x100578, 0x4, 0x4, 0x24;
    byte finalBossHealth : "Rayman2.exe", 0x102D64, 0xE4, 0x0, 0x4, 0x741;
    bool isLoading       : "Rayman2.exe", 0x11663C;
	byte engineMode      : "Rayman2.exe", 0x100380;
}

init
{
   vars.scanForBossHealth = false;
   vars.inMenu = false;
   vars.inControl = false;
   vars.inControlTimer = 0;
}

update
{
    if (!vars.scanForBossHealth && current.levelID.ToLower() == "rhop_10" && current.finalBossHealth == 24)
        vars.scanForBossHealth = true;
		
	if (current.levelID.ToLower() == "menu")
		vars.inMenu = true;
	
	if (current.isLoading) {
		vars.levelTimer = 0;
		vars.inControlTimer = 0;
	}
	
	vars.inControl = ((current.customBits&0x10000) == 0);
	vars.inControlTimer++;
	if (!vars.inControl) {
		vars.inControlTimer = 0;
	}
}

start
{
    if (current.levelID.ToLower() == "jail_20" && old.levelID.ToLower() == "jail_20" && !old.isLoading && !current.isLoading && vars.inControlTimer>5 &&
        (Math.Abs(current.posX - old.posX) > 0.01 || Math.Abs(current.posY - old.posY) > 0.01 || Math.Abs(current.posZ - old.posZ) > 0.01))
        return true; // X/Y/Z position changed
		
	/*if (old.engineMode == 5 && current.engineMode == 9)
	return true;*/
	
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
    if (current.levelID.ToLower() != old.levelID.ToLower() &&
		old.levelID.ToLower() != "menu" && current.levelID.ToLower() != "menu" &
		current.levelID.ToLower() != "raycap" &&
		old.levelID.ToLower() != "mapmonde")
        return true; // level changed
	
    if (vars.scanForBossHealth && current.levelID.ToLower() == "rhop_10" && current.finalBossHealth == 0)
    {
        vars.scanForBossHealth = false;
        return true; // final boss health 0
    }
    return false;
}
