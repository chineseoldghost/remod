LogAlways = System.LogAlways;
LogAlways("iClassSystem | Loading Classes...");

local scanRoot = "scripts/Classes/"
local ioRoot = "scripts/Classes/"
local classes = {};

function loadScript(path)
	Script.UnloadScript("../Classes/"..path);
	Script.LoadScript("../Classes/"..path, 1);
end

function unloadScript(path)
	Script.UnloadScript("../Classes/"..path);
end

function detectClasses()
	local i = 0;
	folders = System.ScanDirectory("../Classes/", 2);
	for k,modPath in ipairs(folders) do
		fileHandle = io.open("../Classes/"..modPath.."/Main.lua", "r");
		if(fileHandle ~= nil) then	
			i = i + 1;
			classes[modPath] = modPath.."/Main.lua";	
			fileHandle:close();		
		end				
	end	
	LogAlways("iClassSystem | Detected ".. tostring(i) .. " classes");
end

function loadClasses()
    local i = 0;
	for k,modPath in pairs(classes) do
		i = i + 1;
		loadScript(""..modPath);
		Log(modPath.." Loaded");
	end
	LogAlways("iClassSystem | Loaded ".. tostring(i) .. " classes");
end

function unloadClasses()
	local i = 0;
	for k,modPath in pairs(classes) do
		i=i+1;
		unloadScript(""..modPath);
	end
	LogAlways("iClassSystem | Unloaded ".. tostring(i) .. " classes");
end

function initClasses()
	detectClasses();
	loadClasses();	
end

loadScript("util.lua");
initClasses();