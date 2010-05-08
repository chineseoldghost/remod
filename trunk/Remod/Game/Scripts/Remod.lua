--Remod = {
--    HQHits = 3;
--};

-- System.SetCVar("r_drawNearFoV", 65)
System.SetCVar("hud_crosshair", 8);

----------------------------------------------------------------------------------------------------
--[[
System.AddCCommand("re_hqhp", "Remod:SetHQHealth, %1", "Sets the amount of hits required to destroy the HQ.");


function Remod:SetHQHealth(hits)
    local hits = tonumber(hits) or 1;
    local health = hits * 6000
    HQ:SetHealth(health);
    HQ.Properties.nHitPoints = health;
    Log("HQ HP set to %d hits", hits);
end
--]]

12405780, 0, "HUD line color.");
	pConsole->Register("hud_colorOver", &hud_colorOver, 14483456, 0, "HUD hovered color.");
	pConsole->Register("hud_colorText", &hud_colorText, 16730698, 0, "HUD text color.");