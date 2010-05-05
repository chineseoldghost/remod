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
--  - 30/ 6/2006   12:30 : Created by M�rcio Martins
--
----------------------------------------------------------------------------------------------------
Script.LoadScript("scripts/gamerules/teaminstantaction.lua", 1, 1);
Script.LoadScript("scripts/gamerules/powerstruggleutils.lua", 1, 1);
--------------------------------------------------------------------------
PowerStruggle = new(TeamInstantAction);
PowerStruggle.States = { "Reset", "PreGame", "InGame", "PostGame", };

-- timers
PowerStruggle.TEAM_CHANGE_MIN_TIME			= 60; -- time before allowing teamchange
PowerStruggle.NEXTLEVEL_TIME						= 22000;
PowerStruggle.ENDGAME_TIME							= 8000;
PowerStruggle.VEHICLE_CLAIM_TIME				= 90; -- seconds to claim a bought vehicle
PowerStruggle.NUKE_SPECTATE_TIMERID			= 1080;
PowerStruggle.NUKE_SPECTATE_TIME				= 2000; -- Remod, default is 2000

-- player/team settings
--PowerStruggle.REVIVE_TIME								= 20;	OBSOLETE: Use g_revivetime instead

PowerStruggle.TIA_SPAWN_LOCATIONS				= false;
PowerStruggle.TEAM_SPAWN_LOCATIONS			= true; -- spawn in teamed spawn points
PowerStruggle.USE_SPAWN_GROUPS					= true;
PowerStruggle.NEUTRAL_SPAWN_LOCATIONS		= false;

-- synched storage keys
PowerStruggle.PP_AMOUNT_KEY 						= 200;
PowerStruggle.CP_AMOUNT_KEY 						= 201;
PowerStruggle.RANK_KEY									= 202;

PowerStruggle.TEAMPOWER_TEAM0_KEY 			= 300;


----------------------------------------------------------------------------------------------------
PowerStruggle.teamName	={ "tan", "black" };
PowerStruggle.teamModel	=
{
	black	={
						{
							"objects/characters/human/us/marine/marine_04_helmet_goggles_on.cdf",
							"objects/weapons/arms_global/arms_nanosuit_us.chr",
							"objects/characters/human/asian/nk_soldier/nk_soldier_frozen_scatter.cgf",
							"objects/characters/human/us/nanosuit/nanosuit_us_fp3p.cdf",
						},
					},

	tan		={
						{
							"objects/characters/human/asian/nk_soldier/nk_soldier_elite_camper_light_gren_03.cdf",
							"objects/weapons/arms_global/arms_nanosuit_asian.chr",
							"objects/characters/human/asian/nk_soldier/nk_soldier_frozen_scatter.cgf",
							"objects/characters/human/asian/nanosuit/nanosuit_asian_fp3p.cdf",
						},
					},
}

PowerStruggle.VehiclePaint=
{
	black	=	"us",
	tan		= "nk",
}

--maximum 4 groups, 5 messages in each (F5-F8, then 1-5). Change Radio.cpp if more needed.
PowerStruggle.teamRadio=
{
	black =
	{
		[1]=
		{
			{"mp_american/us_F5_8_well_done","@mp_radio_WellDone",3},
			{"mp_american/us_F5_5_sorry","@mp_radio_Sorry",3},
			{"mp_american/us_F5_3_wait","@mp_radio_Wait",3},
			{"mp_american/us_F5_4_follow_me","@mp_radio_FollowMe",3},
			{"mp_american/us_F5_6_thank_you","@mp_radio_Thanks",3},
		},
		[2]=
		{
			{"mp_american/us_F6_1_attack_enemy_base","@mp_radio_TakeBase"},
			{"mp_american/us_F6_2_gather_power_cores","@mp_radio_GatherPower"},
			{"mp_american/us_F6_3_take_prototype_factory","@mp_radio_TakePT"},
			{"mp_american/us_F6_4_take_war_factory","@mp_radio_TakeWar"},
			{"mp_american/us_F6_5_take_airfield","@mp_radio_TakeAir"},
		},
		[3]=
		{
			{"mp_american/us_F7_1_armor_spotted","@mp_radio_ArmorSpotted"},
			{"mp_american/us_F7_2_aircraft_spotted","@mp_radio_AircraftSpotted"},
			{"mp_american/us_F7_6_sniper","@mp_radio_Sniper"},
			{"mp_american/us_F7_4_vehicle_spotted","@mp_radio_LTVSpotted"},
			{"mp_american/us_F7_5_infantry_spotted","@mp_radio_InfantrySpotted"},
		},
		[4]=
		{
			{"mp_american/us_F8_1_request_assistance","@mp_radio_Assistance"},
			{"mp_american/us_F8_2_get_into_vehicle","@mp_radio_GetIn"},
			{"mp_american/us_F5_10_request_pickup","@mp_radio_Transport",3},
			{"mp_american/us_F8_4_mechanical_assistance_needed","@mp_radio_MechAssistance"},
			{"mp_american/us_F8_5_radar_scan","@mp_radio_Radar"},
		},
	},
	tan =
	{
		[1]=
		{
			{"mp_korean/nk_F5_8_well_done","@mp_radio_WellDone",3},
			{"mp_korean/nk_F5_5_sorry","@mp_radio_Sorry",3},
			{"mp_korean/nk_F5_3_wait","@mp_radio_Wait",3},
			{"mp_korean/nk_F5_4_follow_me","@mp_radio_FollowMe",3},
			{"mp_korean/nk_F5_6_thank_you","@mp_radio_Thanks",3},
		},
		[2]=
		{
			{"mp_korean/nk_F6_1_attack_enemy_base","@mp_radio_TakeBase"},
			{"mp_korean/nk_F6_2_gather_power_cores","@mp_radio_GatherPower"},
			{"mp_korean/nk_F6_3_take_prototype_factory","@mp_radio_TakePT"},
			{"mp_korean/nk_F6_4_take_war_factory","@mp_radio_TakeWar"},
			{"mp_korean/nk_F6_5_take_airfield","@mp_radio_TakeAir"},
		},
		[3]=
		{
			{"mp_korean/nk_F7_1_armor_spotted","@mp_radio_ArmorSpotted"},
			{"mp_korean/nk_F7_2_aircraft_spotted","@mp_radio_AircraftSpotted"},
			{"mp_korean/nk_F7_6_sniper","@mp_radio_Sniper"},
			{"mp_korean/nk_F7_4_vehicle_spotted","@mp_radio_LTVSpotted"},
			{"mp_korean/nk_F7_5_infantry_spotted","@mp_radio_InfantrySpotted"},
		},
		[4]=
		{
			{"mp_korean/nk_F8_1_request_assistance","@mp_radio_Assistance"},
			{"mp_korean/nk_F8_2_get_into_vehicle","@mp_radio_GetIn"},
			{"mp_korean/nk_F5_10_request_pickup","@mp_radio_Transport",3},
			{"mp_korean/nk_F8_4_mechanical_assistance_needed","@mp_radio_MechAssistance"},
			{"mp_korean/nk_F8_5_radar_scan","@mp_radio_Radar"},
		},
	}
}


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
Net.Expose {
	Class = PowerStruggle,

	ClientMethods = {
		ClSetupPlayer						= { RELIABLE_UNORDERED, NO_ATTACH, DEPENTITYID, },
		ClSetSpawnGroup	 				= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, },
		ClSetPlayerSpawnGroup		= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, ENTITYID },
		ClSpawnGroupInvalid			= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, },
		ClVictory								= { RELIABLE_ORDERED, POST_ATTACH, INT8, INT8, ENTITYID },

		ClStartWorking					= { RELIABLE_ORDERED, POST_ATTACH, ENTITYID; STRINGTABLE },
		ClStepWorking						= { RELIABLE_ORDERED, POST_ATTACH, INT8 },
		ClStopWorking						= { RELIABLE_ORDERED, POST_ATTACH, ENTITYID, BOOL },
		ClWorkComplete					= { RELIABLE_ORDERED, POST_ATTACH, ENTITYID, STRINGTABLE },


		ClClientConnect					= { RELIABLE_UNORDERED, POST_ATTACH, STRING, BOOL },
		ClClientDisconnect			= { RELIABLE_UNORDERED, POST_ATTACH, STRING, },
		ClClientEnteredGame			= { RELIABLE_UNORDERED, POST_ATTACH, STRING, },

		ClEnterBuyZone					= { RELIABLE_ORDERED, NO_ATTACH, DEPENTITYID, BOOL };
		ClEnterServiceZone			= { RELIABLE_ORDERED, NO_ATTACH, DEPENTITYID, BOOL };
		ClEnterCaptureArea			= { RELIABLE_ORDERED, NO_ATTACH, DEPENTITYID, BOOL };

		ClResetBuyZones					= {RELIABLE_ORDERED, POST_ATTACH, };

		ClPerimeterBreached			= { RELIABLE_ORDERED, POST_ATTACH, ENTITYID };
		ClTurretHit							= { RELIABLE_ORDERED, POST_ATTACH, ENTITYID };
		ClHQHit									= { RELIABLE_ORDERED, POST_ATTACH, ENTITYID };
		ClTurretDestroyed				= { RELIABLE_ORDERED, POST_ATTACH, ENTITYID };

		ClMDAlert								= { RELIABLE_UNORDERED, POST_ATTACH, STRING },
		ClMDAlert_ToPlayer			= { RELIABLE_UNORDERED, POST_ATTACH, },
		ClTimerAlert						= { RELIABLE_UNORDERED, POST_ATTACH, INT8 },

		ClBuyError							= { RELIABLE_UNORDERED, POST_ATTACH, STRING, },
		ClBuyOk									= { RELIABLE_UNORDERED, POST_ATTACH, STRING, },

		ClPP										= { RELIABLE_UNORDERED, POST_ATTACH, FLOAT, BOOL },
		ClRank									= { RELIABLE_UNORDERED, POST_ATTACH, INT8, BOOL },
		ClTeamPower							= { RELIABLE_UNORDERED, POST_ATTACH, INT8, FLOAT },

		ClEndGameNear						= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID },

		ClReviveCycle						= { RELIABLE_UNORDERED, POST_ATTACH, BOOL },
	},

	ServerMethods = {
		RequestRevive		 				= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, },
		RequestSpawnGroup				= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, ENTITYID },

		SvBuy							 			= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, STRINGTABLE },
		SvBuyAmmo					 			= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, STRINGTABLE },
		SvRequestPP							= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, INT32 };
		RequestSpectatorTarget	= { RELIABLE_UNORDERED, POST_ATTACH, ENTITYID, INT8 },
	},
	ServerProperties = {
	},
};
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnInit()
	TeamInstantAction.Server.OnInit(self);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:OnInit()
	TeamInstantAction.Client.OnInit(self);

	self:ResetCaptureProgress();
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:OnReset()
	TeamInstantAction.Client.OnReset(self);

	self:ResetCaptureProgress();
end


function PowerStruggle:GatherEntities()
	self.turrets={};
	self.hqs = {};

	local entities=System.GetEntitiesByClass("Factory");
	if (entities) then
		self.factories={};
		for i,v in pairs(entities) do
			table.insert(self.factories, v);
		end
	end

	local entities=System.GetEntitiesByClass("Objective");
	if (entities) then
		self.objectives={};
		for i,v in pairs(entities) do
			table.insert(self.objectives, v);
		end
	end

	-- get turrets
	local turrets=System.GetEntitiesByClass( "AutoTurret" );
	if (turrets) then
		for i,turret in pairs(turrets) do
			table.insert(self.turrets, turret.id);
		end
	end

	-- get aa turrets
	local aaturrets=System.GetEntitiesByClass( "AutoTurretAA" );
	if (aaturrets) then
		for i,turret in pairs(aaturrets) do
			table.insert(self.turrets, turret.id);
		end
	end

	-- get hq
	local hqs=System.GetEntitiesByClass( "HQ" );
	for i,hq in pairs(hqs) do
		table.insert(self.hqs, hq.id);
	end
end

----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnStartGame()
	TeamInstantAction.Server.OnStartGame(self);

	self:GatherEntities();
end
----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:OnStartGame()
	if (HUD) then
		HUD.SetObjectiveStatus("PS.Obj1_CapturePT", MO_DEACTIVATED, 1);
		HUD.SetObjectiveStatus("PS.Obj2_SecureAliens", MO_DEACTIVATED, 1);
		HUD.SetObjectiveStatus("PS.Obj3_BuildTAC", MO_DEACTIVATED, 1);
		HUD.SetObjectiveStatus("PS.Obj4_DestroyHQ", MO_DEACTIVATED, 1);
		HUD.SetObjectiveStatus("PS.SecObj1_Factory", MO_DEACTIVATED, 1);
		HUD.SetObjectiveStatus("PS.SecObj2_Bunker", MO_DEACTIVATED, 1);
		HUD.SetObjectiveStatus("PS.SecObj3_Turret", MO_DEACTIVATED, 1);
		HUD.SetMainObjective("PS.Obj1_CapturePT");
	end

	if (not self.isServer) then
		self:GatherEntities();
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:Reset(forcePregame)
	if (g_localActor and HUD) then
		HUD.ResetBuyZones();
	end
	self.inBuyZone={};
	self.inServiceZone={};
	self.unclaimedVehicle={};
	self.reviveQueue={};

	self:ResetMinimap();
	self:ResetPower();

	self.game:ResetReviveCycleTime();

	TeamInstantAction.Reset(self, forcePregame);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnClientConnect(channelId, reset, name)
	local player=TeamInstantAction.Server.OnClientConnect(self, channelId, reset, name);

	if (not CryAction.IsChannelOnHold(channelId)) then
		self:ResetScore(player.id);
		self:ResetPP(player.id);
		self:ResetCP(player.id);
	end

	self:ResetRevive(player.id);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnClientEnteredGame(channelId, player, reset)
	TeamInstantAction.Server.OnClientEnteredGame(self, channelId, player, reset);

	if (player) then
--fixing devTrack issue 37381 - always assignt starting PP to connecting player
		self:SetPlayerPP(player.id, self.ppList.START);
		self.onClient:ClResetBuyZones(player.actor:GetChannel());
		if (self.inBuyZone[player.id]) then
			for zoneId,yes in pairs(self.inBuyZone[player.id]) do
				if (yes) then
					self.onClient:ClEnterBuyZone(player.actor:GetChannel(), zoneId, true);
				end
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnClientDisconnect(channelId)
	TeamInstantAction.Server.OnClientDisconnect(self, channelId);
	local player=self.game:GetPlayerByChannelId(channelId);

	if (player) then
		self:ResetRevive(player.id, true);

		self:VehicleOwnerDeath(player);
		self:ResetUnclaimedVehicle(player.id, true);

		self.inBuyZone[player.id]=nil;
		self.inServiceZone[player.id]=nil;
	end
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:CheckTimeLimit()
	if (self.game:IsTimeLimited() and self.game:GetRemainingGameTime()<=0) then
		local state=self:GetState();
		if (state and state~="InGame") then
			return;
		end

		local draw=false;

		local maxE;
		local maxTeamId;

		for i,teamId in pairs(self.teamId) do
			local energy = self:GetTeamPower(teamId);
			if (not maxE) then
				maxE=energy;
				maxTeamId=teamId;
			else
				if (maxE == energy) then
					draw = true;
				else if(energy > maxE) then
							maxE=energy;
							maxTeamId=teamId;
							end
				end
			end
		end

		if (not draw) then
			self:OnGameEnd(maxTeamId, 2);
		else
			if(self.overtimeAdded ~= nil) then
				self:OnGameEnd(nil, 2);
			else
				local overtimeTime=3;
				self.game:AddOvertime(overtimeTime);
				self.game:SendTextMessage(TextMessageBig, "@ui_msg_overtime_0", TextMessageToAll, nil, overtimeTime);
				self.overtimeAdded = 1;
			end
--			self:OnGameEnd(nil, 2);
		end
	end
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:AutoTeamBalanceSwitchPlayer(player, dstTeamId)

	self.game:SendTextMessage(TextMessageCenter, "@mp_AutoTeamBalanceSwapYou", TextMessageToClient, player.id);
	self.game:SendTextMessage(TextMessageCenter, "@mp_AutoTeamBalanceSwap", TextMessageToOtherClients, player.id, player:GetName());

	self:QueueRevive(player.id);
	self.Server.RequestSpawnGroup(self, player.id, NULL_ENTITY, true);
	self.game:SetTeam(dstTeamId, player.id);
	self.Server.RequestSpawnGroup(self, player.id, self.game:GetTeamDefaultSpawnGroup(dstTeamId) or NULL_ENTITY, true);
	player.last_team_change=_time;
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:AutoTeamBalanceCanSwitchPlayer(player, dstTeamId)
	return player:IsDead();
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:SetUnclaimedVehicle(vehicleId, ownerId, teamId, vehicleName, buildingId, gateId)
	local vehicle={};

	vehicle.ownerId=ownerId;
	vehicle.teamId=teamId;
	vehicle.name=vehicleName;
	vehicle.buildingId=buildingId;
	vehicle.gate=gateId;
	vehicle.time=self.VEHICLE_CLAIM_TIME;

	self.unclaimedVehicle[vehicleId]=vehicle;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:UpdateUnclaimedVehicles(frameTime)
	for id,v in pairs(self.unclaimedVehicle) do
		v.time=v.time-frameTime;
		if (v.time<=0) then
			-- inform the player
			self.game:SendTextMessage(TextMessageInfo, "@mp_UnclaimedVehicle", TextMessageToClient, v.ownerId, g_gameRules:GetItemName(v.name));
			-- refund
			local price=self:GetPrice(v.name);
			if (price and price>0) then
				self:AwardPPCount(v.ownerId, math.floor(self.ppList.VEHICLE_REFUND_MULT*price+0.5));
			end

			System.RemoveEntity(id);

			self.unclaimedVehicle[id]=nil;
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ClaimedVehicle(vehicleId, playerId)
	local vehicle=self.unclaimedVehicle[vehicleId];

	if (vehicle and vehicle.ownerId == playerId) then
		self.unclaimedVehicle[vehicleId]=nil;
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ResetUnclaimedVehicle(playerId, unlock)
	for i,v in pairs(self.unclaimedVehicle) do
		if (v.ownerId==playedId) then
			if (unlock) then
				vehicle.vehicle:SetOwnerId(NULL_ENTITY);
				self.game:SetTeam(v.teamId, v.id);
			end

			self.unclaimedVehicle[i]=nil;
			return;
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:OnPurchaseCancelled(playerId, teamId, itemName)
	local price,energy=self:GetPrice(itemName);
	if (price>0) then
		self:AwardPPCount(playerId, price);
	end

	if (energy and energy>0) then
		self:SetTeamPower(teamId, self:GetTeamPower(teamId)+energy);
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:OnVehicleUnlocked(vehicleId, playerId)
	g_gameRules.game:SendTextMessage(TextMessageInfo, "@mp_VehicleUnlocked", TextMessageToClient, playerId);
	g_gameRules.game:SetTeam(self.game:GetTeam(playerId), vehicleId);

	local vehicle=System.GetEntity(vehicleId);
	if (vehicle) then
		vehicle.vehicle:SetOwnerId(NULL_ENTITY);
	end

	self.unclaimedVehicle[vehicleId]=nil;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnVehicleDestroyed(vehicleId)
	for playerId,zones in pairs(self.inBuyZone) do
		if (zones[vehicleId]) then
			local player=System.GetEntity(playerId);
			if (player and player.actor) then
				self.onClient:ClEnterBuyZone(player.actor:GetChannel(), vehicleId, false);
			end

			zones[vehicleId]=nil;
		end
	end

	for playerId,zones in pairs(self.inServiceZone) do
		if (zones[vehicleId]) then
			local player=System.GetEntity(playerId);
			if (player and player.actor) then
				self.onClient:ClEnterServiceZone(player.actor:GetChannel(), vehicleId, false);
			end

			zones[vehicleId]=nil;
		end
	end

	self.unclaimedVehicle[vehicleId]=nil;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:OnVehicleSubmerged(vehicleId, ratio)
	self:OnVehicleDestroyed(vehicleId);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client.OnSetBuyFlags(g_gameRules, entityId, flags)
	if (HUD) then
		HUD.UpdateBuyList();
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:AbandonPlayerVehicle(playerId, currentVehicleId, destroy)
	local player=System.GetEntity(playerId);
	if (not player) then
		return;
	end

	if (player.lastPSVehicleId and ((not currentVehicleId) or player.lastPSVehicleId~=currentVehicleId)) then
		local lastVehicle=System.GetEntity(player.lastPSVehicleId);
		if (lastVehicle) then
			if (lastVehicle.lastOwnerId and lastVehicle.lastOwnerId==playerId and lastVehicle.vehicle:IsEmpty() and (not self.game:IsSpawnGroup(player.lastPSVehicleId))) then
				if (destroy) then
					lastVehicle.vehicle:Destroy();
				else
					lastVehicle.vehicle:StartAbandonTimer(true, 20);
				end
			end
			lastVehicle.lastOwnerId=nil;
		end
		player.lastPSVehicleId=nil;
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:OnEnterVehicleSeat(vehicle, seat, entityId)

	-- moved setting of team to TIA. Parachute is done in IA version now.
	TeamInstantAction.OnEnterVehicleSeat(self, vehicle, seat, entityId);

	if (self.isServer) then

		local player=System.GetEntity(entityId);
		if (player) then
			self:AbandonPlayerVehicle(player.id, vehicle.id);
		end

		if(entityId==vehicle.vehicle:GetOwnerId()) then
			-- this is the owner entering the vehicle
			vehicle.vehicle:SetOwnerId(NULL_ENTITY);
		end

		vehicle.vehicle:KillAbandonTimer();

		if (self.unclaimedVehicle[vehicle.id]) then
			self.unclaimedVehicle[vehicle.id]=nil;
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:OnLeaveVehicleSeat(vehicle, seat, entityId, exiting)
	if (self.isServer) then
		if (exiting) then
			local empty=true;
			for i,seat in pairs(vehicle.Seats) do
				local passengerId = seat:GetPassengerId();
				if (passengerId and passengerId~=NULL_ENTITY and passengerId~=entityId) then
					empty=false;
					break;
				end
			end

			local player=System.GetEntity(entityId);
			if (empty) then
				--self.game:SetTeam(0, vehicle.id);
				vehicle.lastOwnerId=entityId;
				if (player) then
					player.lastPSVehicleId=vehicle.id;
				end
			end

			if(entityId==vehicle.vehicle:GetOwnerId()) then
				vehicle.vehicle:SetOwnerId(NULL_ENTITY);
			end

			-- always set last entered vehicle (used for no collision damage within x seconds of exit)
			if(player) then
				player.lastExitedVehicleId = vehicle.id;
				player.lastExitedVehicleTime = _time;
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:VehicleOwnerDeath(player)
 self:AbandonPlayerVehicle(player.id);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnPlayerKilled(hit)
	TeamInstantAction.Server.OnPlayerKilled(self, hit);

	local deadGuy=hit.target;

	if (deadGuy and deadGuy.actor) then
		self:VehicleOwnerDeath(deadGuy);

		local revive=self.reviveQueue[deadGuy.id];
		if (revive and revive.tk==true) then
			return
		end
		local rank=self.rankList[self:GetPlayerRank(deadGuy.id)];
		if (rank and rank.min_pp and rank.min_pp>0) then
			local currentpp=self:GetPlayerPP(deadGuy.id);
			if (currentpp<rank.min_pp) then
				self:AwardPPCount(deadGuy.id, rank.min_pp-currentpp);
			end
		end
	end
end
	
-- Remod, start killstreak function
-- And yes bla i'm gonna comment everything for you lalz

--[[
function killstreak (shooter,target)
 if (shooter==target) then -- Make sure that its not triggered by suicide
	 target.killstreak = 0;
	return;
end

 shooter.killstreak = shooter.killstreak +1;

-- Killstreaks
if (shooter.killstreak==3) then -- Just change the 3 to any number you would like
      g_gameRules:AwardPPCount(shooter,50); -- Do the same with the PP Amount you wish to have
end
if (shooter.killstreak==4) then
     g_gameRules:AwardPPCount(shooter,25);
end
if (shooter.killstreak==5) then
      g_gameRules:AwardPPCount(shooter,25);
end
if (shooter.killstreak==6) then
      g_gameRules:AwardPPCount(shooter,75);
end
if (shooter.killstreak==7) then
      g_gameRules:AwardPPCount(shooter,25);
end
if (shooter.killstreak==8) then
      g_gameRules:AwardPPCount(shooter,25);
end
if (shooter.killstreak==9) then
      g_gameRules:AwardPPCount(shooter,100);
end
if (shooter.killstreak > 9) then
g_gamerules:AwardPPCount(shooter,25);
end
-- Resetting Killstreak after Death
		target.Killstreak = 0;
end
-- Remod, end killstreak function


end
--]]



----------------------------------------------------------------------------------------------------
function PowerStruggle:ShatterEntity(entityId, hit)
	TeamInstantAction.ShatterEntity(self, entityId, hit);

	if (hit.target and hit.target.actor) then
		self:VehicleOwnerDeath(hit.target);
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnUpdate(frameTime)
	TeamInstantAction.Server.OnUpdate(self, frameTime);

	self:UpdateUnclaimedVehicles(frameTime);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:OnUpdate(frameTime)
	TeamInstantAction.Client.OnUpdate(self, frameTime);

	self:UpdateObjectives();
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnTimer(timerId, msec)
	if(timerId == self.NUKE_SPECTATE_TIMERID) then
		local players=self.game:GetPlayers();
		local targetplayer = System.GetEntity(self.nukePlayer or NULL_ENTITY);
		if (players) then
			for i,player in pairs(players) do
				if(targetplayer and player.id ~= self.nukePlayer) then
					player.inventory:Destroy();
					self.game:ChangeSpectatorMode(player.id, 3, targetplayer.id);
					--player.actor:SetSpectatorMode(3, targetplayer.id);
				else
					-- oops. Spectate the HQ directly?
				end
			end
		end
	end

	TeamInstantAction.Server.OnTimer(self, timerId, msec);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:OnRevive(playerId, pos, rot, teamId)
	TeamInstantAction.Client.OnRevive(self, playerId, pos, rot, teamId);
end

----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:OnReviveInVehicle(playerId, vehicleId, seatId, teamId)
	TeamInstantAction.Client.OnRevive(self, playerId, vehicleId, seatId, teamId);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:OnTick()
	if (self:GetState()~="PostGame") then
		self:UpdateReviveQueue();
	end

	TeamInstantAction.OnTick(self);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:RequestRevive(playerId)
	local player = System.GetEntity(playerId);

	if (player and player.actor) then
		-- allow respawn if spectating player and on a team
		if (((player.actor:GetSpectatorMode() == 3 and self.game:GetTeam(playerId)~=0) or (player:IsDead() and player.death_time and _time-player.death_time>2.5)) and (not self:IsInReviveQueue(playerId))) then
			self:QueueRevive(playerId);
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:QueueRevive(playerId)
	local revive=self.reviveQueue[playerId];

	if (not revive) then
		self:ResetRevive(playerId);
		revive=self.reviveQueue[playerId];
	end

	revive.active=true;

	local player=System.GetEntity(playerId);
	if (player) then
		self.channelSpectatorMode[player.actor:GetChannel()]=nil;
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ClearReviveQueue()
	for playerId,revive in pairs(self.reviveQueue) do
		revive.active=false;
		revive.announced=nil;
		revive.overdue=nil;
		revive.overdue_clearance=nil;
		revive.items={};
		revive.items_price=0;
		revive.ammo={};
		revive.ammo_price=0;
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:FlushReviveQueue()
	for playerId,revive in pairs(self.reviveQueue) do
		if (revive.active) then
			local player=System.GetEntity(playerId);
			if (player) then
				if (self:RevivePlayer(player.actor:GetChannel(), player)) then
					revive.active=false;
					revive.announced=nil;
					revive.overdue=nil;
					revive.overdue_clearance=nil;
				end
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ReviveAllPlayers()
	-- set the teams in the revive queue
	for playerId,revive in pairs(self.reviveQueue) do
		if (revive.active) then
			revive.active=false;
			revive.announced=nil;
			revive.overdue=nil;
			revive.overdue_clearance=nil;

			revive.items={};
			revive.items_price=0;
			revive.ammo={};
			revive.ammo_price=0;

			local player=System.GetEntity(playerId);
			if (player and player.actor:GetSpectatorMode()~=0) then
				self.game:ChangeSpectatorMode(player.id, 0, NULL_ENTITY);
			end
		end
	end

	TeamInstantAction.ReviveAllPlayers(self);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ResetRevive(playerId, remove)
	if (remove) then
		self.reviveQueue[playerId]=nil;
	else
		local revive=self.reviveQueue[playerId];
		if (not revive) then
			revive={};
			self.reviveQueue[playerId]=revive;
		end

		revive.active=false;
		revive.announced=nil;
		revive.overdue=nil;
		revive.overdue_clearance=nil;
		revive.tk=nil;

		revive.items={};
		revive.items_price=0;
		revive.ammo={};
		revive.ammo_price=0;
	end

	local player = System.GetEntity(playerId);
	if(player and player.actor) then
		self.onClient:ClReviveCycle(player.actor:GetChannel(), false);
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:IsInReviveQueue(playerId)
	return self.reviveQueue[playerId] and self.reviveQueue[playerId].active;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:CommitRevivePurchases(playerId)
	local revive=self.reviveQueue[playerId];
	local player=System.GetEntity(playerId);

	for ammo,c in pairs(revive.ammo) do
		player.actor:SetInventoryAmmo(ammo, c, CLIENT_SIDE + SERVER_SIDE);
	end
	self:AwardPPCount(playerId, -revive.ammo_price);

	local ok=false;
	for i,itemName in ipairs(revive.items) do
		ok=false;
-- no need to check this now- PP already substructed on buy
--		if (self:EnoughPP(playerId, itemName)) then
			ok=self:BuyItem(playerId, itemName, true, true);
--		end

		if (not ok) then
			break;
		end
	end

	revive.ammo={};
	revive.items={};
	revive.items_price=0;
	revive.ammo_price=0;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:UpdateReviveQueue()
	local reviveTimer=self.game:GetRemainingReviveCycleTime();

	if (reviveTimer>0) then
		for playerId,revive in pairs(self.reviveQueue) do
			if (revive.active) then
				local player=System.GetEntity(playerId);
				if (player and player.spawnGroupId and player.spawnGroupId~=NULL_ENTITY) then
					if ((not revive.announced) and (not revive.overdue)) then
						self.onClient:ClReviveCycle(player.actor:GetChannel(), true);
						revive.announced=true;
					end
				elseif (revive.announced) then -- spawngroup got invalidated while spawn cycle was up,
																			 -- so need to make sure it gets sent again after the situation is cleared
					revive.announced=nil;
				end

				if (revive.overdue and self:CanRevive(playerId)) then
					if (not revive.overdue_clearance) then
						revive.overdue_clearance=_time;
					elseif (_time-revive.overdue_clearance>=2) then
						self:RevivePlayerInQueue(player, revive);
					end
				else
					revive.overdue_clearance=nil;
				end
			end
		end

		-- if player has been dead more than 5s and isn't spectating, auto-switch to spectator mode 3
		local players=self.game:GetPlayers();
		if (players) then
			for i,player in pairs(players) do
				if(player and player:IsDead() and player.death_time and _time-player.death_time>5 and player.actor:GetSpectatorMode() == 0) then
					self.Server.RequestSpectatorTarget(self, player.id, 1);
				end
			end
		end
	end

	if (reviveTimer<=0) then
		self.game:ResetReviveCycleTime();

		for i,teamId in ipairs(self.teamId) do
			self:UpdateTeamRanks(teamId);
		end

		for playerId,revive in pairs(self.reviveQueue) do
			local player=System.GetEntity(playerId);
			if (player) then
				if (revive.active and self:CanRevive(playerId)) then
					self:RevivePlayerInQueue(player, revive);
				elseif (revive.active) then
					local groupId=player.spawnGroupId;
					if ((not groupId) or (groupId==NULL_ENTITY)) then
						if (not revive.overdue) then
							if (not revive.announced) then
								local channelId=player.actor:GetChannel();
								self.onClient:ClReviveCycle(channelId, true);
								self.onClient:ClSpawnGroupInvalid(channelId, NULL_ENTITY);
								revive.announced=true;
							end
							revive.overdue=true;
						end
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:RevivePlayerInQueue(player, revive)
	revive.active=false;

	self:RevivePlayer(player.actor:GetChannel(), player);
	-- processing PP now in OnPlayerKilled
--	if (not revive.tk) then
--		local rank=self.rankList[self:GetPlayerRank(player.id)];
--		if (rank and rank.min_pp and rank.min_pp>0) then
--			local currentpp=self:GetPlayerPP(player.id);
--			if (currentpp<rank.min_pp) then
--				self:AwardPPCount(player.id, rank.min_pp-currentpp);
--			end
--		end
--	end

	self:CommitRevivePurchases(player.id);

	revive.tk=nil;
	revive.announced=nil;
	revive.overdue=nil;
	revive.overdue_clearance=nil;
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:RevivePlayer(channelId, player)
	if (player.actor:GetSpectatorMode()~=0) then
		self.game:ChangeSpectatorMode(player.id, 0, NULL_ENTITY);
	end

	local result=TeamInstantAction.RevivePlayer(self, channelId, player);

	self:ResetUnclaimedVehicle(player.id, false);

	player.lastPSVehicleId=nil;

	return result;
end

----------------------------------------------------------------------------------------------------
-- only players get this
function PowerStruggle.Server:OnChangeSpectatorMode(playerId, mode, targetId, resetAll)
	if(resetAll) then
		self:ResetPP(playerId);
		self:ResetCP(playerId);
	end

	TeamInstantAction.Server.OnChangeSpectatorMode(self, playerId, mode, targetId, resetAll, true);

	if(resetAll and mode>0) then
		self:ResetRevive(playerId);
	end
end


----------------------------------------------------------------------------------------------------
-- only players get this, for entities see OnSetTeam
function PowerStruggle.Server:OnChangeTeam(playerId, teamId)
	local oldTeamId=self.game:GetTeam(playerId);
	if (teamId ~= oldTeamId) then
		local player=System.GetEntity(playerId);
		if (player) then
			if (player.last_team_change and teamId~=0) then
				if (self:GetState()=="InGame") then
					if (_time-player.last_team_change<self.TEAM_CHANGE_MIN_TIME) then
						if ((not player.last_team_change_warning) or (_time-player.last_team_change_warning>=4)) then
							player.last_team_change_warning=_time;
							self.game:SendTextMessage(TextMessageError, "@mp_TeamChangeLimit", TextMessageToClient, playerId, self.TEAM_CHANGE_MIN_TIME-math.floor(_time-player.last_team_change+0.5));
						end
						return;
					end
				end
			end

			if (self:IsTeamLocked(teamId, playerId)) then
				if ((not player.last_team_locked_warning) or (_time-player.last_team_locked_warning>=4)) then
					player.last_team_locked_warning=_time;
					Log("team change request by %s denied: team %d has too many players", EntityName(playerId), teamId);
					self.game:SendTextMessage(TextMessageError, "@mp_TeamLockedTooMany", TextMessageToClient, playerId);
				end
				return;
			end

			if (player.actor:GetHealth()>0 and player.actor:GetSpectatorMode()==0) then
				self:KillPlayer(player);
			end

			if (teamId~=0) then
				self:QueueRevive(playerId);
				self.game:SetTeam(teamId, playerId);
				self.Server.RequestSpawnGroup(self, player.id, self.game:GetTeamDefaultSpawnGroup(teamId) or NULL_ENTITY, true);

				player.last_team_change=_time;
			end
		end

		for i,factory in pairs(self.factories) do
			factory:CancelJobForPlayer(playerId);
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnSetTeam(entityId, teamId)
	local entity=System.GetEntity(entityId);
	if (entity) then
		entity.last_scanned=nil;
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:OnSetTeam(entityId, teamId)
	if (entityId == g_localActorId) then
		if (HUD) then
			HUD.UpdateBuyList();
			HUD.SetObjectiveStatus("PS.Obj1_CapturePT", MO_DEACTIVATED, 1);
			HUD.SetObjectiveStatus("PS.Obj2_SecureAliens", MO_DEACTIVATED, 1);
			HUD.SetObjectiveStatus("PS.Obj3_BuildTAC", MO_DEACTIVATED, 1);
			HUD.SetObjectiveStatus("PS.Obj4_DestroyHQ", MO_DEACTIVATED, 1);
			HUD.SetObjectiveStatus("PS.SecObj1_Factory", MO_DEACTIVATED, 1);
			HUD.SetObjectiveStatus("PS.SecObj2_Bunker", MO_DEACTIVATED, 1);
			HUD.SetObjectiveStatus("PS.SecObj3_Turret", MO_DEACTIVATED, 1);
			HUD.SetMainObjective("PS.Obj1_CapturePT");

			self:UpdateObjectives();
		end
	else
		local entity=System.GetEntity(entityId);
		if (entity.GetBuyFlags and (entity:GetBuyFlags()~=0)) then -- TODO: more robust way to check if the entity is a buy area
			HUD.UpdateBuyList();
		end
	end

	local entity=System.GetEntity(entityId);
	if (entity) then
		if (entity.OnSetTeam) then
			entity:OnSetTeam(teamId);
		end
	end
end

----------------------------------------------------------------------------------------------------

function PowerStruggle:ShouldAutoRespawn()
	return false;
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:ProcessScores(hit, tk)
	TeamInstantAction.ProcessScores(self, hit, tk);

	if (self:GetState()=="PostGame") then return; end

	local shooter=hit.shooter;
	if (shooter and shooter.actor and shooter.actor:IsPlayer()) then
		self:AwardKillPP(hit);
		self:AwardKillCP(hit);
	end
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:SetTeamScore(teamId, score)
	self.game:SetSynchedGlobalValue(self.TEAMSCORE_TEAM0_KEY+teamId, score);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ProcessVehicleScores(targetId, shooterId)

	local target=System.GetEntity(targetId);

	if (shooterId) then
		local vTeam=self.game:GetTeam(targetId);
		local sTeam=self.game:GetTeam(shooterId);

		if ((vTeam~=0) and (vTeam~=sTeam)) then
			local pp=self.ppList.VEHICLE_KILL_MIN;
			local cp=self.cpList.VEHICLE_KILL_MIN;

			if (target.builtas) then
				local def=self:GetItemDef(target.builtas);
				if (def) then
					pp=math.max(pp, math.floor(def.price*self.ppList.VEHICLE_KILL_MULT));
					cp=math.max(cp, math.floor(def.price*self.cpList.VEHICLE_KILL_MULT));
				end
			end

			self:AwardPPCount(shooterId, pp);
			self:AwardCPCount(shooterId, cp);
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:PrecacheLevel()
	TeamInstantAction.PrecacheLevel(self);

	for i,v in pairs(self.buyList) do
		if (v.weapon or v.equip or v.proto) then
			if (v.class) then
			 	if (type(v.class)=="string" and v.class~="") then
					CryAction.CacheItemGeometry(v.class);
					CryAction.CacheItemSound(v.class);
				elseif (type(v.class)=="table") then
					for k,j in pairs(v.class) do
						CryAction.CacheItemGeometry(j);
						CryAction.CacheItemSound(j);
					end
				end
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:ClResetBuyZones()
	if (g_localActor and HUD) then
		HUD.ResetBuyZones();
		HUD.UpdateBuyList();
	end
end

----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:ClEnterBuyZone(zoneId, enable)
	if (g_localActor and HUD) then
		HUD.EnteredBuyZone(zoneId, enable);
		HUD.UpdateBuyList();
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:ClEnterServiceZone(zoneId, enable)
	if (g_localActor and HUD) then
		HUD.EnteredServiceZone(zoneId, enable); -- change this to be service zone if needed...
		HUD.UpdateBuyList();
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:ClReviveCycle(show)
	HUD.ShowReviveCycle(show);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client:ClSpawnGroupInvalid(spawnGroupId)
	TeamInstantAction.Client.ClSpawnGroupInvalid(self, spawnGroupId);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ResetPlayers()
	TeamInstantAction.ResetPlayers(self);

	self:ClearReviveQueue();

	local players=self.game:GetPlayers();
	if (players) then
		for i,player in pairs(players) do
			player.last_team_change=nil;
			if (player.actor:GetSpectatorMode()==0 or player.actor:GetSpectatorMode()==3) then
				self:ResetPP(player.id);
				self:ResetCP(player.id);
				self:SetPlayerPP(player.id, self.ppList.START);

				local teamId=self.game:GetTeam(player.id) or 0;
				self.Server.RequestSpawnGroup(self, player.id, self.game:GetTeamDefaultSpawnGroup(teamId) or NULL_ENTITY, true);
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:ResetMinimap()
	self.game:ResetMinimap();
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:OnDisarmed(entityId, disarmerId)
	if (self.game:GetTeam(entityId)~=self.game:GetTeam(disarmerId)) then
	-- give the player some PP
		self:AwardPPCount(disarmerId, self.ppList.DISARM);
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:OnAddTaggedEntity(shooterId, targetId)
	-- give players PP and CP for tagging enemies
	local shooterTeam = self.game:GetTeam(shooterId);
	local targetTeam = self.game:GetTeam(targetId);
	if((targetTeam~=0) and (shooterTeam ~= targetTeam)) then
		local target=System.GetEntity(targetId);
		if (target) then
			if ((not target.last_scanned) or (_time-target.last_scanned>16)) then
				self:AwardPPCount(shooterId, self.ppList.TAG_ENEMY);
				self:AwardCPCount(shooterId, self.cpList.TAG_ENEMY);
				target.last_scanned=_time;
			end
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:DefaultState(cs, state)
	local default=self[cs];
	self[cs][state]={
		OnClientConnect = default.OnClientConnect,
		OnClientDisconnect = default.OnClientDisconnect,
		OnClientEnteredGame = default.OnClientEnteredGame,
		OnDisconnect = default.OnDisconnect, -- client only
		OnActorAction = default.OnActorAction, -- client only
		OnStartLevel = default.OnStartLevel,
		OnStartGame = default.OnStartGame,

		OnKill = default.OnKill,
		OnHit = default.OnHit,
		OnFreeze = default.OnFreeze,
		OnExplosion = default.OnExplosion,
		OnChangeTeam = default.OnChangeTeam,
		OnChangeSpectatorMode = default.OnChangeSpectatorMode,
		RequestSpectatorTarget = default.RequestSpectatorTarget,
		OnSetTeam = default.OnSetTeam,
		OnItemPickedUp = default.OnItemPickedUp,
		OnItemDropped = default.OnItemDropped,
		OnMineDisarmed = default.OnMineDisarmed,
		OnAddTaggedEntity = default.OnAddTaggedEntity,

		OnTimer = default.OnTimer,
		OnUpdate = default.OnUpdate,
	}
end

----------------------------------------------------------------------------------------------------
PowerStruggle:DefaultState("Server", "Reset");
PowerStruggle:DefaultState("Client", "Reset");

----------------------------------------------------------------------------------------------------
PowerStruggle:DefaultState("Server", "PreGame");
PowerStruggle:DefaultState("Client", "PreGame");

----------------------------------------------------------------------------------------------------
PowerStruggle:DefaultState("Server", "InGame");
PowerStruggle:DefaultState("Client", "InGame");

----------------------------------------------------------------------------------------------------
PowerStruggle:DefaultState("Server", "PostGame");
PowerStruggle:DefaultState("Client", "PostGame");

----------------------------------------------------------------------------------------------------
PowerStruggle.Server.PostGame.OnChangeTeam = nil;
--PowerStruggle.Server.PostGame.OnChangeSpectatorMode = nil;


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client.PreGame:OnBeginState()
	TeamInstantAction.Client.PreGame.OnBeginState(self);
end

----------------------------------------------------------------------------------------------------
function PowerStruggle.Server.PreGame:OnBeginState()
	self:ResetAlerts();
	self:ResetMinimap();

	TeamInstantAction.Server.PreGame.OnBeginState(self);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server.PreGame:OnTick()
	TeamInstantAction.Server.PreGame.OnTick(self);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client.PreGame:OnTick()
	TeamInstantAction.Client.PreGame.OnTick(self);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server.InGame:OnBeginState()
	TeamInstantAction.Server.InGame.OnBeginState(self);

	self:ResetAlerts();
	self:ResetMinimap();

	CryAction.SendGameplayEvent(NULL_ENTITY, eGE_GameStarted, "", 1);--server
end

----------------------------------------------------------------------------------------------------
function PowerStruggle.Client.InGame:OnBeginState()
	CryAction.SendGameplayEvent(NULL_ENTITY, eGE_GameStarted, "", 0);--client
	self.overtimeAdded = nil;
end

----------------------------------------------------------------------------------------------------
function PowerStruggle.Server.InGame:OnUpdate(frameTime)
	PowerStruggle.Server.OnUpdate(self, frameTime);

	self:CheckTimeLimit();
	self:UpdateClAlerts();
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server.InGame:OnTick()
	self:PowerTick();

	TeamInstantAction.Server.InGame.OnTick(self);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server.PostGame:OnBeginState()
	TeamInstantAction.Server.PostGame.OnBeginState(self);

	CryAction.SendGameplayEvent(NULL_ENTITY, eGE_GameEnd, "", 1);--server

	self:SetTimer(self.NUKE_SPECTATE_TIMERID, self.NUKE_SPECTATE_TIME);

	self:ResetAlerts();
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client.PostGame:OnBeginState()
	TeamInstantAction.Client.PostGame.OnBeginState(self);

	--This will be called in InstantAction.Client.PostGame.OnBeginState
	--CryAction.SendGameplayEvent(NULL_ENTITY, eGE_GameEnd, "", 1);--server

	if (HUD) then
		HUD.OpenPDA(false, false);
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Client.PostGame:OnEndState()
	TeamInstantAction.Client.PostGame.OnEndState(self);

	if (self.victorySoundId) then
		Sound.StopSound(self.victorySoundId);
		self.victorySoundId=nil;
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:RequestSpectatorTarget(playerId, change)
	--special check: must be either a) not in a team or b) dead
	local team = self.game:GetTeam(playerId);
	local player = System.GetEntity(playerId);
	local mode = player.actor:GetSpectatorMode();
	if(not player:IsDead() and team ~= 0 and mode ~= 3) then
		return;
	end

	TeamInstantAction.Server.RequestSpectatorTarget(self, playerId, change);
end


----------------------------------------------------------------------------------------------------
function PowerStruggle.Server:SvRequestPP(playerId, amount)
	if (g_gameRules.game:CanCheat()) then
		self:AwardPPCount(playerId, amount);
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:OnTeamKill(targetId, shooterId)
	local revive=self.reviveQueue[shooterId];
	if (not revive) then
		self:ResetRevive(shooterId);
		revive=self.reviveQueue[shooterId];
	end

	revive.tk=true;

	TeamInstantAction.OnTeamKill(self, targetId, shooterId);
end


----------------------------------------------------------------------------------------------------
function GivePP(amt)
	if (g_gameRules.isServer) then
		if (g_gameRules.game:CanCheat()) then
			g_gameRules:AwardPPCount(g_localActorId, amt);
		end
	else
		g_gameRules.server:SvRequestPP(g_localActorId, amt);
	end
end


----------------------------------------------------------------------------------------------------
function GivePPToAll(amt)
	if (g_gameRules.game:CanCheat()) then
		for i,v in g_gameRules.game:GetPlayers() do
			g_gameRules:AwardPPCount(v.id, amt);
		end
	end
end


----------------------------------------------------------------------------------------------------
function PowerStruggle:DisplayKillScores()
	return false;
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:CalculateScore(deaths, kills, teamkills)

	return kills;
end

----------------------------------------------------------------------------------------------------
function PowerStruggle:UpdateObjectives()
	if(g_localActorId) then
		local playerTId=self.game:GetTeam(g_localActorId);

		--find out what team the PT factory is owned by
		local ptFactoryTId = 0;
		if(self.factories) then
			for i,factory in pairs(self.factories) do
				if (factory.Properties.buyOptions and factory.Properties.buyOptions.bPrototypes == 1) then
					ptFactoryTId=self.game:GetTeam(factory.id);
				end
			end
		end

		--find out how much power has been collected
		local power = self.game:GetSynchedGlobalValue(self.TEAMPOWER_TEAM0_KEY+playerTId);

		--work out if there is a TAC weapon somewhere
		--TODO

		--update objectives: secondary always active
		HUD.SetObjectiveStatus("PS.SecObj1_Factory", MO_DEACTIVATED, 1);
		HUD.SetObjectiveStatus("PS.SecObj2_Bunker", MO_DEACTIVATED, 1);
		HUD.SetObjectiveStatus("PS.SecObj3_Turret", MO_DEACTIVATED, 1);

		if(ptFactoryTId==playerTId and playerTId~=0) then
			if(power==100) then
				local obj = HUD.GetMainObjective();
				if(obj ~= "PS.Obj4_DestroyHQ") then
					HUD.SetMainObjective("PS.Obj3_BuildTAC");
				end
			else
				HUD.SetMainObjective("PS.Obj2_SecureAliens");
			end
		else
			HUD.SetMainObjective("PS.Obj1_CapturePT");
		end
	end
end


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
Script.LoadScript("scripts/gamerules/powerstrugglebuying.lua", 1, 1);
Script.LoadScript("scripts/gamerules/powerstrugglerank.lua", 1, 1);
Script.LoadScript("scripts/gamerules/powerstrugglealert.lua", 1, 1);
