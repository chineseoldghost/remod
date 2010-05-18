--------------------------------------------------------------------------
--	Crytek Source File.
-- 	Copyright (C), Crytek Studios, 2001-2006.
--------------------------------------------------------------------------
--	$Id$
--	$DateTime$
--	Description: GameRules implementation for Power Struggle
--  
--------------------------------------------------------------------------
--  History:
--  - 30/ 6/2006   12:30 : Created by Márcio Martins
--
----------------------------------------------------------------------------------------------------
PowerStruggle.rankList=
{
	{ name="@ui_short_rank_1", 	desc="@ui_rank_1",	cp=0, 		min_pp=100,		equip={ "SOCOM", "Binoculars", "NightVision", "Parachute"	},},
	{ name="@ui_short_rank_2",	desc="@ui_rank_2",	cp=4, 		min_pp=125,		equip={ "SOCOM", "Binoculars", "NightVision", "Parachute"	},},
	{ name="@ui_short_rank_3", 	desc="@ui_rank_3",	cp=8, 		min_pp=150,		equip={ "SOCOM", "Binoculars", "NightVision", "Parachute"	},},
	{ name="@ui_short_rank_4", 	desc="@ui_rank_4",  cp=16,		min_pp=175,		equip={ "SOCOM", "Binoculars", "NightVision", "Parachute"	},},
	{ name="@ui_short_rank_5", 	desc="@ui_rank_5",	cp=32, 	min_pp=200,		equip={ "SOCOM", "Binoculars", "NightVision", "Parachute"	},},
	{ name="@ui_short_rank_6", 	desc="@ui_rank_6",	cp=64, 	min_pp=225,		equip={ "SOCOM", "Binoculars", "NightVision", "Parachute"	},},
	{ name="@ui_short_rank_7", 	desc="@ui_rank_7",	cp=128,	 	min_pp=250,		equip={ "SOCOM", "SOCOM", "Binoculars", "NightVision", "Parachute"	},},
	{ name="@ui_short_rank_8", 	desc="@ui_rank_8",	cp=256, 	min_pp=275,	  	equip={ "SOCOM", "SOCOM", "Binoculars", "NightVision", "Parachute"	},},
};


PowerStruggle.cpList=
{
	KILL                        = 2,
	KILL_RANKDIFF_MULT          = 1,
	TURRETKILL                  = 0,
	REPAIR                      = 0,
	LOCKPICK                    = 1,
	CAPTURE                     = 3,
	BUYVEHICLE						 = 0,
	TAG_ENEMY						 = 0,	--TODO once design is confirmed
   TEAMKILL                    = -2,
 --  MELEE                       = 5,

	VEHICLE_KILL_MIN			= 0,
	VEHICLE_KILL_MULT			= 0,

	--DISARM                = 5,
	--ATTACKING_FACILITY        = 5,
	--DEFENDING_FACILITY        = 5,
	KILLING_TAC_WEAPON_BEARER = 4,
};


----------------------------------------------------------------------------------------------------
function PowerStruggle:EquipPlayer(player, additionalEquip)
	if(self.game:IsDemoMode() ~= 0) then -- don't equip actors in demo playback mode, only use existing items
		Log("Don't Equip : DemoMode");
		return;
	end;

	player.inventory:Destroy();

	ItemSystem.GiveItem("AlienCloak", player.id, false);
	ItemSystem.GiveItem("OffHand", player.id, false);
	--ItemSystem.GiveItem("Fists", player.id, false);
	
	if (additionalEquip and additionalEquip~="") then
		ItemSystem.GiveItemPack(player.id, additionalEquip, true);
	end

	local rank=self:GetPlayerRank(player.id);
	if ((not rank) or (rank<1)) then
		rank=1;
	end

	local equip=self.rankList[rank].equip;
	if (equip) then
		for k,e in ipairs(equip) do
			ItemSystem.GiveItem(e, player.id, false);
		end
	end
	local teamId = self.game:GetTeam(player.id);
	if(teamId==1) then
		ItemSystem.GiveItem("SCAR", true);
	elseif(teamId==2) then
		ItemSystem.GiveItem("FY71", true);
	end

	--[[local channelId = self.game:GetChannelId(player.id);
	self.game:ForceSynchedStorageSynch(channelId);
	--local Value=self.game:GetSynchedEntityValue(player.id, self.CLASS_KEY);
	if(self.game:GetClass(player.id, "sniper")) then
		ItemSystem.GiveItem(self.sniperProperties.PrimaryWeapon, player.id, true);
		System.LogAlways("2");
		ItemSystem.GiveItem("SniperScope", player.id, true);
	elseif(self.game:GetClass(player.id, "rifleman")) then
		System.LogAlways("4");
		ItemSystem.GiveItem(self.riflemanProperties.PrimaryWeapon, player.id, true);
	elseif(self.game:GetClass(player.id, "engineer")) then
		ItemSystem.GiveItem(self.engineerProperties.PrimaryWeapon, player.id, true);
	end]]--
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:GetPlayerRank(playerId)
	return self.game:GetSynchedEntityValue(playerId, self.RANK_KEY) or 1;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:SetPlayerRank(playerId, rank)
	CryAction.SendGameplayEvent(playerId, eGE_Rank, nil, rank);
	return self.game:SetSynchedEntityValue(playerId, self.RANK_KEY, rank);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:GetPlayerRankName(playerId)
	return self:GetRankName(self:GetPlayerRank(playerId));
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:GetRankName(rank, longName, includeShortName)
	local rankdef=self.rankList[rank];
	if (rankdef) then
		if (not longName) then
			return rankdef.name;
		--elseif (includeShortName) then
		--	return string.format("%s (%s)", rankdef.desc, rankdef.name);
		else
			return rankdef.desc;
		end
	end
	return;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:GetRankCP(rank)
	local rankdef=self.rankList[rank];
	if (rankdef) then
		return rankdef.cp;
	end
	return;
end


function PowerStruggle:GetRankPP(rank)
	local rankdef=self.rankList[rank];
	if (rankdef) then
		return rankdef.min_pp;
	end
	return;
end



----------------------------------------------------------------------------------------------------
function PowerStruggle:UpdateTeamRanks(teamId)
	function compare_by_cp(player1, player2)
		local id1=player1.id;
		local id2=player2.id;
		
		local cp1=self.game:GetSynchedEntityValue(id1, self.CP_AMOUNT_KEY) or 0;
		local cp2=self.game:GetSynchedEntityValue(id2, self.CP_AMOUNT_KEY) or 0;

		if (cp1==cp2) then
			local s1=self.game:GetSynchedEntityValue(id1, self.SCORE_KILLS_KEY) or 0;
			local s2=self.game:GetSynchedEntityValue(id2, self.SCORE_KILLS_KEY, 0) or 0;
			
			if (s1==s2) then
				local d1=self.game:GetSynchedEntityValue(id1, self.SCORE_DEATHS_KEY) or 0;
				local d2=self.game:GetSynchedEntityValue(id2, self.SCORE_DEATHS_KEY) or 0;				

				return d1<d2;
			else
				return s1>s2
			end
		else
			return cp1>cp2;
		end
	end

	local players=self.game:GetTeamPlayers(teamId);
	if (players) then
		table.sort(players, compare_by_cp);
		
		local maxrank=table.getn(self.rankList);
		local currranki=maxrank;
		local rank=self.rankList[currranki];
		local rankc=0;
		
		for i,player in ipairs(players) do
			local playerId=player.id;
			local currcp=self.game:GetSynchedEntityValue(playerId, self.CP_AMOUNT_KEY) or 0;
			while((currcp<rank.cp or (rank.limit and rankc>=rank.limit)) and currranki>1) do
				currranki=currranki-1;
				rank=self.rankList[currranki];
				rankc=0;
			end
			
			rankc=rankc+1;
			
			local oldrank=self.game:GetSynchedEntityValue(playerId, self.RANK_KEY) or 1;
			if (oldrank~=currranki) then
				self.game:SetSynchedEntityValue(playerId, self.RANK_KEY, currranki);

				if (oldrank<currranki) then
				 	-- promoted
				 	self.onClient:ClRank(player.actor:GetChannel(), currranki, true);
				else
					-- demoted
					self.onClient:ClRank(player.actor:GetChannel(), currranki, false);
				end
				
				CryAction.SendGameplayEvent(playerId, eGE_Rank, nil, currranki);
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ResetCP(playerId)
	self:SetPlayerCP(playerId, 0);
	self:SetPlayerRank(playerId, 1);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:SetPlayerCP(playerId, cp)
	self.game:SetSynchedEntityValue(playerId, self.CP_AMOUNT_KEY, cp);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:GetPlayerCP(playerId)
	return self.game:GetSynchedEntityValue(playerId, self.CP_AMOUNT_KEY) or 0;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:CalcKillCP(hit)
	local target=hit.target;
	local shooter=hit.shooter;
	local headshot=self:IsHeadShot(hit);

	if(target ~= shooter) then
		local team1=self.game:GetTeam(shooter.id);
		local team2=self.game:GetTeam(target.id);
		if(team1 ~= team2) then
			local ownRank = self:GetPlayerRank(shooter.id);
			local enemyRank = self:GetPlayerRank(target.id);

			return self.cpList.KILL+math.max(0, (enemyRank-ownRank)*self.cpList.KILL_RANKDIFF_MULT);
		else
			return -10;
		end
	end
	
	return 0;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:AwardKillCP(hit)
	local cp=self:CalcKillCP(hit);
	
	self:AwardCPCount(hit.shooter.id, cp);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:AwardCPCount(playerId, c)
	self:SetPlayerCP(playerId, self:GetPlayerCP(playerId)+c);
end
