System.LogAlways("iClassSystem | Loading Classes...");
 
local scanRoot = "scripts/Classes/"
local classes = {};
 
function loadClasses()
	classes = System.ScanDirectory(scanRoot, 2);
    	for k,modPath in ipairs(classes) do
		if not (modPath==".svn") then
			local success = Script.LoadScript("scripts/Classes/"..modPath.."/Main.lua", 1);
                	if (success) then
                    		System.LogAlways("iClassSystem | Loaded class "..modPath);
			else
				System.LogAlways("iClassSystem | Failed to load class "..modPath);
			end
		else
			System.LogAlways("iClassSystem | Skipping SVN folder "..modPath);
		end
    	end
end

function SetClass()
	class = self.actor:GetClass();
	for k,modPath in ipairs(classes) do
		if(modPath==class) then
			if(class=="Sniper") then
				Sniper.Activate();
			end
		end
	end
end

loadClasses();