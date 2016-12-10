local CTFLastTimeRemaining = -1;

BattleHerald_WorldFrames = { "BattleHerald_CTFWorldFrame", "BattleHerald_ABWorldFrame", "BattleHerald_EOTSWorldFrame",
    "BattleHerald_BFGWorldFrame", "BattleHerald_AVWorldFrame", "BattleHerald_ICWorldFrame" };
    
BattleHerald_WorldFrameDragEnabled = false;

BattleHerald_SlashCommands["toggleui"] = function(msg)
	BattleHerald_WorldFrameDragEnabled = not BattleHerald_WorldFrameDragEnabled;
	if (BattleHerald_WorldFrameDragEnabled) then
		DEFAULT_CHAT_FRAME:AddMessage(BHSTR_UI_DRAG_ENABLED);
	else
		DEFAULT_CHAT_FRAME:AddMessage(BHSTR_UI_DRAG_DISABLED);
	end
end;

BattleHerald_SlashCommands["resetui"] = function(msg)
	BattleHerald_WorldFrameDragEnabled = false;
	DEFAULT_CHAT_FRAME:AddMessage(BHSTR_UI_RESET);
	
	for i = 1, #BattleHerald_WorldFrames do
        _G[BattleHerald_WorldFrames[i]]:SetUserPlaced(false);
        _G[BattleHerald_WorldFrames[i]]:ClearAllPoints();
        _G[BattleHerald_WorldFrames[i]]:SetPoint("TOP", "UIParent", "TOP", 0, 12);
    end
end;

function BattleHerald_StartWorldFrameDragging()

	if (not BattleHerald_WorldFrameDragEnabled) then
		return;
	end

	for i = 1, #BattleHerald_WorldFrames do
		if (_G[BattleHerald_WorldFrames[i]]:IsShown()) then
			_G[BattleHerald_WorldFrames[i]]:StartMoving();
		end
    end

end

function BattleHerald_StopWorldFrameDragging()

	for i = 1, #BattleHerald_WorldFrames do
        _G[BattleHerald_WorldFrames[i]]:StopMovingOrSizing();
    end

end

-- Sets the scale of all WorldFrames to be as set in the UserOptions
function BattleHerald_UpdateWorldFrameScale(opt, value)

    for i = 1, #BattleHerald_WorldFrames do
        _G[BattleHerald_WorldFrames[i]]:SetScale(value / 100.0);
    end

end

function BattleHerald_IsCTFActive()

	local zone = GetInstanceInfo();
	return (zone == "Warsong Gulch" and BattleHerald_GetUserOption("WARSONG_GULCH_UI")) or 
		   (zone == "Twin Peaks" and BattleHerald_GetUserOption("TWIN_PEAKS_UI"));

end

function BattleHerald_IsABActive()

	local zone = GetInstanceInfo();
	return zone == "Arathi Basin" and BattleHerald_GetUserOption("ARATHI_BASIN_UI");

end

function BattleHerald_IsEOTSActive()

	local zone = GetInstanceInfo();
	return zone == "Eye of the Storm" and BattleHerald_GetUserOption("EYE_OF_THE_STORM_UI");

end

function BattleHerald_IsAVActive()

	local zone = GetInstanceInfo();
	return zone == BHSTR_ALTERAC_VALLEY and BattleHerald_GetUserOption("ALTERAC_VALLEY_UI");

end

function BattleHerald_IsBFGActive()

	local zone = GetInstanceInfo();
	return zone == "The Battle for Gilneas" and BattleHerald_GetUserOption("THE_BATTLE_FOR_GILNEAS_UI");

end

function BattleHerald_IsICActive()

	local zone = GetInstanceInfo();
	return zone == "Isle of Conquest" and BattleHerald_GetUserOption("ISLE_OF_CONQUEST_UI");

end

-- Switches to the specified WorldStateFrame or switches them off if they're inactive
function BattleHerald_SwitchWorldStateFrame(which)

	if (which == "CTF") then
		BattleHerald_CTFWorldFrame:Show();
	else
		BattleHerald_CTFWorldFrame:Hide();
	end
	if (which == "AB") then
		BattleHerald_ABWorldFrame:Show();
	else
		BattleHerald_ABWorldFrame:Hide();
	end
	if (which == "EOTS") then
		BattleHerald_EOTSWorldFrame:Show();
	else
		BattleHerald_EOTSWorldFrame:Hide();
	end
	if (which == "BFG") then
		BattleHerald_BFGWorldFrame:Show();
	else
		BattleHerald_BFGWorldFrame:Hide();
	end
	if (which == "AV") then
		BattleHerald_AVWorldFrame:Show();
	else
		BattleHerald_AVWorldFrame:Hide();
	end
	if (which == "IC") then
		BattleHerald_ICWorldFrame:Show();
	else
		BattleHerald_ICWorldFrame:Hide();
	end
	if (which == "OFF") then
		BattleHerald_UnhackWorldStateFrame();
		WorldStateAlwaysUpFrame:Show();
	else
		BattleHerald_HackWorldStateFrame();
		WorldStateAlwaysUpFrame:Hide();
	end

end

function BattleHerald_CTFEvent(self, event)
	
	local _, state, _, text = GetWorldStateUIInfo(2);
	if (text) then
		if (state == 1) then
			BattleHerald_CTFWorldFrame_HordeFlagIcon:Hide();
			BattleHerald_CTFWorldFrame_HordeFlagIconFlash:Hide();
		else
			BattleHerald_CTFWorldFrame_HordeFlagIcon:Show();
			BattleHerald_CTFWorldFrame_HordeFlagIconFlash:Show();
			BattleHerald_CTFWorldFrame_HordeFlagIconFlash.flash:Play();
		end
		BattleHerald_CTFWorldFrame_AllianceFrame_Text:SetText(strsub(text, 0, 1));
	end
	
	_, state, _, text = GetWorldStateUIInfo(3);
	if (text) then
		if (state == 1) then
			BattleHerald_CTFWorldFrame_AllianceFlagIcon:Hide();
			BattleHerald_CTFWorldFrame_AllianceFlagIconFlash:Hide();
		else
			BattleHerald_CTFWorldFrame_AllianceFlagIcon:Show();
			BattleHerald_CTFWorldFrame_AllianceFlagIconFlash:Show();
			BattleHerald_CTFWorldFrame_AllianceFlagIconFlash.flash:Play();
		end
		BattleHerald_CTFWorldFrame_HordeFrame_Text:SetText(strsub(text, 0, 1));
	end
	
	_, state, _, text = GetWorldStateUIInfo(1);
	local time = tonumber(strsub(text, strfind(text, ":") + 2, strfind(text, " min") - 1));
	if (time ~= CTFLastTimeRemaining) then
		-- Update the timer bar
		BattleHerald_CTFWorldFrame_Timer.val = time*60;
		CTFLastTimeRemaining = time;
	end
	
end

function BattleHerald_ABEvent(self, event)
	
	local _, state, _, text = GetWorldStateUIInfo(1);
	BattleHerald_ABWorldFrame_AllianceFrame_Text:SetText(strsub(text, strfind(text, "Resources: ")+11, strfind(text, "/1600")-1));
	
	_, state, _, text = GetWorldStateUIInfo(2);
	BattleHerald_ABWorldFrame_HordeFrame_Text:SetText(strsub(text, strfind(text, "Resources: ")+11, strfind(text, "/1600")-1));
	
end

function BattleHerald_AVEvent(self, event)
	
	if (event == "WORLD_MAP_UPDATE") then
		BattleHerald_UpdateAVTowers();
	else
		local _, state, _, text = GetWorldStateUIInfo(1);
		BattleHerald_AVWorldFrame_AllianceFrame_Text:SetText(strsub(text, strfind(text, "Reinforcements: ")+16));
		
		_, state, _, text = GetWorldStateUIInfo(2);
		BattleHerald_AVWorldFrame_HordeFrame_Text:SetText(strsub(text, strfind(text, "Reinforcements: ")+16));
	end
	
end

function BattleHerald_ICEvent(self, event)
	
	local _, state, _, text = GetWorldStateUIInfo(1);
	BattleHerald_ICWorldFrame_AllianceFrame_Text:SetText(strsub(text, strfind(text, "Reinforcements: ")+16));
	
	_, state, _, text = GetWorldStateUIInfo(2);
	BattleHerald_ICWorldFrame_HordeFrame_Text:SetText(strsub(text, strfind(text, "Reinforcements: ")+16));
	
end

function BattleHerald_UpdateAVTowers()

	-- Count red and blue towers.
	-- Update the texts.
	local rCount = 0;
	local bCount = 0;
	
	local name, description, textureIndex, x, y;
	for i = 1, GetNumMapLandmarks() do
		_, _, index, _, _ = GetMapLandmarkInfo(i);
		if (index == 10 or index == 9) then
			rCount = rCount + 1;
		elseif (index == 11 or index == 12) then
			bCount = bCount + 1;
		end
	end
	
	BattleHerald_AVWorldFrame_AllianceTowersText:SetText(bCount);
	BattleHerald_AVWorldFrame_HordeTowersText:SetText(rCount);
	
end

function BattleHerald_EOTSEvent(self, event)
	
	local _, state, _, text = GetWorldStateUIInfo(2);
	BattleHerald_EOTSWorldFrame_AllianceFrame_Text:SetText(strsub(text, strfind(text, "Victory Points: ")+16, strfind(text, "/1600")-1));
	
	_, state, _, text = GetWorldStateUIInfo(3);
	BattleHerald_EOTSWorldFrame_HordeFrame_Text:SetText(strsub(text, strfind(text, "Victory Points: ")+16, strfind(text, "/1600")-1));
	
	local name, frame, frameText, frameDynamicIcon, frameIcon, frameFlash, flashTexture, frameDynamicButton;
	local uiType, state, _, text, icon, dynamicIcon, tooltip, dynamicTooltip, extendedUI, extendedUIState1, extendedUIState2, extendedUIState3 = GetWorldStateUIInfo(1);
	local extendedUIShown = 1;
	-- Taken from WorldStateUI.lua
	if ( state > 0 ) then
		if ( extendedUI ~= "" ) then
			-- extendedUI
			uiInfo = ExtendedUI[extendedUI]
			name = uiInfo.name..extendedUIShown;
			if ( extendedUIShown > NUM_EXTENDED_UI_FRAMES ) then
				frame = uiInfo.create(extendedUIShown);
				NUM_EXTENDED_UI_FRAMES = extendedUIShown;
			else
				frame = _G[name];
			end
			uiInfo.update(extendedUIShown, extendedUIState1, extendedUIState2, extendedUIState3);
			frame:Show();
			extendedUIShown = extendedUIShown + 1;
		end
	end
	for i=extendedUIShown, NUM_EXTENDED_UI_FRAMES do
		frame = _G["WorldStateCaptureBar"..i];
		if ( frame ) then
			frame:Hide();
		end
	end
	
end

function BattleHerald_BFGEvent(self, event)
	
	local _, state, _, text = GetWorldStateUIInfo(1);
	BattleHerald_BFGWorldFrame_AllianceFrame_Text:SetText(strsub(text, strfind(text, "Resources: ")+11, strfind(text, "/2000")-1));
	
	_, state, _, text = GetWorldStateUIInfo(2);
	BattleHerald_BFGWorldFrame_HordeFrame_Text:SetText(strsub(text, strfind(text, "Resources: ")+11, strfind(text, "/2000")-1));
	
end

function BattleHerald_HackWorldStateFrame()

	WorldStateAlwaysUpFrame:UnregisterEvent("UPDATE_WORLD_STATES");
	WorldStateAlwaysUpFrame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE");
	WorldStateAlwaysUpFrame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	WorldStateAlwaysUpFrame:UnregisterEvent("ZONE_CHANGED");
	WorldStateAlwaysUpFrame:UnregisterEvent("ZONE_CHANGED_INDOORS");
	WorldStateAlwaysUpFrame:UnregisterEvent("ZONE_CHANGED_NEW_AREA");
	WorldStateAlwaysUpFrame:UnregisterEvent("PLAYER_ENTERING_BATTLEGROUND");
	WorldStateAlwaysUpFrame:UnregisterEvent("WORLD_STATE_UI_TIMER_UPDATE");

end

function BattleHerald_UnhackWorldStateFrame()

	WorldStateAlwaysUpFrame:RegisterEvent("UPDATE_WORLD_STATES");
	WorldStateAlwaysUpFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	WorldStateAlwaysUpFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	WorldStateAlwaysUpFrame:RegisterEvent("ZONE_CHANGED");
	WorldStateAlwaysUpFrame:RegisterEvent("ZONE_CHANGED_INDOORS");
	WorldStateAlwaysUpFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	WorldStateAlwaysUpFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
	WorldStateAlwaysUpFrame:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE");

end

function BattleHerald_FormatTime(seconds)
	
	local minutes = floor(seconds / 60.0);
	local secs = floor(seconds % 60);
	
	local ret = "";
	if (minutes < 10) then
		ret = ret .. "0" .. minutes;
	else
		ret = ret .. minutes;
	end
	ret = ret .. ":";
	if (secs < 10) then
		ret = ret .. "0" .. secs;
	else
		ret = ret .. secs;
	end
	return ret;
	
end

function BattleHerald_UpdateCTFTimer(self, elapsed)
	
	if (self.val == nil) then
		self.val = 1500;
	end
	self.val = self.val - elapsed;
	if (self.val >= 0) then
		self:SetValue(self.val);
	else
		self:SetValue(0);
	end
	
	_G[self:GetName().."_Text"]:SetText(BattleHerald_FormatTime(self:GetValue()));
	
end

function BattleHerald_WorldFrameAllianceFlagTaken(event, arg1, arg2, arg3, arg4, arg5)
	
    BattleHerald_CTFWorldFrame_AllianceFlagIcon.tooltip = arg5;

end

function BattleHerald_WorldFrameHordeFlagTaken(event, arg1, arg2, arg3, arg4, arg5)

    BattleHerald_CTFWorldFrame_HordeFlagIcon.tooltip = arg5;

end
