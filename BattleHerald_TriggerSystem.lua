--[[
BattleHerald_TriggerSystem.lua
Implements the Trigger system that in turn shows Text Alerts and executes Sound Alerts
]]--

function BattleHerald_InitializeTriggersFrame()

	local frame = CreateFrame("Frame", "BattleHerald_TriggersFrame");
	frame:SetScript("OnEvent", BattleHerald_TriggerSystemEvent);
	BattleHerald_TriggerSystemLoad();

end

function BattleHerald_TriggerSystemLoad()
	
	for k, v in pairs(BattleHerald_Triggers) do
		-- Register for the events in the Trigger list.
		BattleHerald_TriggersFrame:RegisterEvent(v.event);
	end
	
end

local function HomeStyle()

	if (GetBattlefieldArenaFaction() == 0) then
		return "HORDE";
	else
		return "ALLIANCE";
	end

end

local function EnemyStyle()

	if (GetBattlefieldArenaFaction() == 0) then
		return "ALLIANCE";
	else
		return "HORDE";
	end

end

function BattleHerald_GetStyleByActor(actor)

	-- Looks for the specified actor in the player's raid.
	-- If it finds it, returns back the player's faction as style.
	-- Enemy faction, otherwise.
	
	for i = 1, GetNumRaidMembers() do
		if (UnitName("raid"..i) == actor) then
			return HomeStyle();
		end
	end
	
	return EnemyStyle();

end

local function LocalizeFactionStyle(style)

	if (style == "ALLIANCE") then
		return BHSTR_ALLIANCE;
	else
		return BHSTR_HORDE;
	end	
	
end

-- /run BattleHerald_TriggerSystemEvent(BattleHerald_TriggersFrame, "CHAT_MSG_BG_SYSTEM_NEUTRAL", "Test Trigger", nil, nil, nil, "Klishu");

function BattleHerald_TriggerSystemEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)

	local match;
	if (arg5 == "" or arg5 == nil) then
		match = arg1;
	else
		match = gsub(arg1, arg5, "%%s");
	end
	for k, v in pairs(BattleHerald_Triggers) do
		if (event == v.event and (GetRealZoneText() == v.zone or GetInstanceInfo() == v.zone)) then
			if (match == v.match) then
				if (BattleHerald_GetUserOption(v.textOpt) and v.text[1]) then
					-- Show the text alert!			
					-- Use %t to substitute in the localized faction name
					if (v.actorStyle) then
						local style = BattleHerald_GetStyleByActor(arg5);
						BattleHerald_AddToTextQueue(gsub(v.text[1], "%%t", LocalizeFactionStyle(style)), style);
					else
						BattleHerald_AddToTextQueue(v.text[1], v.style);
					end
				end
				if (BattleHerald_GetUserOption(v.soundOpt) and v.sound[1] and v.sound[2]) then
					-- Play the sound
					-- Use %t to substitute in the localized faction name
					if (v.actorStyle) then
						local style = BattleHerald_GetStyleByActor(arg5);
						BattleHerald_AddSoundToQueueByKey(v.sound[1], gsub(v.sound[2], "%%T", style));
					else
						BattleHerald_AddSoundToQueueByKey(v.sound[1], v.sound[2]);
					end
				end
				if (v.handler) then
				    -- Trigger has a handler. Execute it.
				    v.handler(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
				end
				return;
			end
		end
	end	

end

-- Attach a handler function to a trigger (referred to it by its label).
-- When that trigger is executed, the handler is also called.
-- The handler will be passed the event and the event args up to arg11.
function BattleHerald_SetTriggerHandler(label, handler)

    assert(label, "Invalid Trigger label specified.");
    assert(handler, "Invalid Trigger handler specified.");

    local i;
    for i = 1, #BattleHerald_Triggers do
        if (BattleHerald_Triggers[i].label == label) then
            BattleHerald_Triggers[i].handler = handler;
        end
    end

end

BattleHerald_InitializeTriggersFrame();
