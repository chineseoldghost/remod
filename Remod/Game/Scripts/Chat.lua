function Chat:SendChatToTarget(from, to, fmt, ...)
	SendChatGeneric(ChatToTarget, from, to, fmt);
end

function Chat:SendChatToTeam(from, fmt, ...)
	SendChatGeneric(ChatToTeam, from, to, fmt);
end

function Chat:SendChatToAll(from, fmt, ...)
	SendChatGeneric(ChatToAll, from, to, fmt);
end

function Chat:SendChatGeneric(mode, from, to, msg)
	local fromId = NULL_ENTITY;
	local toId = NULL_ENTITY;
	if (from) then
		fromId = from.id;
	else
		if (System.GetEntityByName("Resys: ")) then
			fromId = System.GetEntityByName("Resys: ").id
		else
			SetChatEntity();
			if (System.GetEntityByName("Resys: ")) then
				fromId = System.GetEntityByName(Resys: ).id
			end
		end
	end
	if (to) then
		toId = to.id;
	else
		if (System.GetEntityByName("Resys: ")) then
			toId = System.GetEntityByName("Resys: ").id
		else 
            SetChatEntity();
			if (System.GetEntityByName("Resys: ")) then
				fromId = System.GetEntityByName("Resys: ").id
			end
		end  --Continue anyway with NULL_ENTITY as the toId
	end
	if (fromId==System.GetEntityByName("Resys: ").id) then
		g_gameRules.game:SendChatMessage(mode, fromId, toId, msg);
	end
end

function Chat:SetChatEntity()
	if (System.GetEntityByName("Resys: ")) then
		LogAlways("$6[RESYS] Chat Entity Already Set");
		return;
	end
	local params = {
		class = "SMG";
		position = {x = 1, y = 1, z = 3000};
		orientation = {x = 0, y = 0, z = 1};
		name = "Resys: ";
		properties = {
			bAdjustToTerrain = 1;
			Respawn = {
				bRespawn = 1;
				nTimer = 1;
				bUnique = 1;
				};
				};
				};
	local Chat = System.SpawnEntity(params);
	if (Chat) then
        CreateActor(Chat);
		if (g_gameRules and g_gameRules.class == "InstantAction") then
			g_gameRules.game:SetTeam(0, Chat.id);
		else
			g_gameRules.game:SetTeam(2, Chat.id);
		end
		LogAlways("$3[RESYS] Succesfully spawned chat entity %s", Chat:GetName());
	else
		LogAdmins("$4[RESYS] Spawn of %s chat entity failed", class);
	end
	return
end