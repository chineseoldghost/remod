LogAlways = System.LogAlways;
LogAlways("iClassSystem | Loading Classes...");

local scanRoot = "/"
local ioRoot = "/"
local classes = {};

function loadScript(path)
	Script.UnloadScript(""..path);
	Script.LoadScript(""..path, 1);
end

function unloadScript(path)
	Script.UnloadScript("/"..path);
end

function detectClasses()
	--getn seems to not work on dictionaries. prolly just b/c i'm a lua noob :P
	local i = 0;
	folders = System.ScanDirectory(scanRoot, SCANDIR_SUBDIRS);
	for k,ClassPath in ipairs(folders) do
		fileHandle = io.open(ioRoot..ClassPath.."/Main.lua", "r");
		if(fileHandle ~= nil) then	
			i = i + 1;
			classes[ClassPath] = ClassPath.."/Main.lua";	
			fileHandle:close();		
		end				
	end	
	LogAlways("iClassSystem | Detected ".. tostring(i) .. " classes");
end

function loadClasses()
    local i = 0;
	for k,ClassPath in pairs(classes) do
		i = i + 1;
		loadScript(""..ClassPath);
		Log(ClassPath.." Loaded");
	end
	LogAlways("iClassSystem | Loaded ".. tostring(i) .. " classes");
end

function unloadClasses()
	local i = 0;
	for k,ClassPath in pairs(classes) do
		i=i+1;
		unloadScript(""..ClassPath);
	end
	LogAlways("iClassSystem | Unloaded ".. tostring(i) .. " classes");
end

function initClasses()
	detectClasses();
	loadClasses();	
end

loadScript("util.lua");
initClasses();