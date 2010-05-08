System.LogAlways("Loading Classes...");	
local scanRoot = "scripts/Classes/"

ClassSystem.classProperties = {	
	health = 100.0,
	normalSpeed = 0.5,
	maxSpeed = 0.3,
	characterModel = "objects/characters/human/us/nanosuit/nanosuit_us_multiplayer.cdf",
	handsModel = "objects/weapons/arms_global/arms_nanosuit_us.chr",
	mass = 50,
	sprintMultiplier = 1,
	jumpHeight = 0.3,
}
System.LogAlways("1");	

ClassSystem.sniperProperties= {
	health = 50.0,
	normalSpeed = 1.3,
	maxSpeed = 3.0,
	characterModel = "objects/characters/human/us/nanosuit/nanosuit_us_multiplayer.cdf",
	handsModel = "objects/weapons/arms_global/arms_nanosuit_us.chr",
	mass = 90,
	sprintMultiplier = 3.0,
	jumpHeight = 1.0,
}
System.LogAlways("2");	

ClassSystem.riflemanProperties= {
	health = 100.0,
	normalSpeed = 1.3,
	maxSpeed = 3.0,
	characterModel = "objects/characters/human/us/nanosuit/nanosuit_us_multiplayer.cdf",
	handsModel = "objects/weapons/arms_global/arms_nanosuit_us.chr",
	mass = 90,
	sprintMultiplier = 1.1,
	jumpHeight = 2.0,
}

ClassSystem.engineerProperties= {
	health = 75.0,
	normalSpeed = 1.3,
	maxSpeed = 3.0,
	characterModel = "objects/characters/human/us/nanosuit/nanosuit_us_multiplayer.cdf",
	handsModel = "objects/weapons/arms_global/arms_nanosuit_us.chr",
	mass = 90,
	sprintMultiplier = 1.0,
	jumpHeight = 0.2,
}
System.LogAlways("3");	
----------------------------------------------------------------------------------------------------

function ClassSystem:loadClasses()
	classes = System.ScanDirectory(scanRoot, 2);
    	for k,modPath in ipairs(classes) do
		if not (modPath==".svn") then
			local success = Script.LoadScript("scripts/Classes/"..modPath.."/Main.lua", 1);
                	if (success) then
                    		System.LogAlways("Loaded class "..modPath);
			else
				System.LogAlways("Failed to load class "..modPath);
			end
		else
			System.LogAlways("Skipping SVN folder "..modPath);
		end
    	end
end
System.LogAlways("4");	
----------------------------------------------------------------------------------------------------
function ClassSystem:SetClass()
	class = self.actor:GetClass();
	if(class=="Sniper") then
		self.currentClass = self.SniperProperties;
	end
	if(class=="Rifleman") then
		self.currentClass = self.riflemanProperties;
	end
	if(class=="Engineer") then
		self.currentClass = self.engineerProperties;
	end
	System.LogAlways("Successfully activated class");
end
System.LogAlways("5");	
----------------------------------------------------------------------------------------------------
function ClassSystem:SetClassProperties()
	System.LogAlways("YAY1");	
	local success = self:SetClass();
	System.LogAlways("YAY2");
	if(success) then	
		System.LogAlways("YAY3");
		g_gameRules:SetMaxHealth(currentClass.health);
		System.LogAlways("YAY4");
		g_gameRules:SetJumpHeight(currentClass.jumpHeight);
		System.LogAlways("YAY5");
		g_gameRules:SetSprintMultiplier(currentClass.sprintMultiplier);
		System.LogAlways("Class properties successfully set");
	else
		System.LogAlways("Failed to set class properties");
	end
end
System.LogAlways("6");	