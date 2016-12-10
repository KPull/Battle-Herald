--[[
BattleHerald_Main.lua
Starting point for the addon
]]--

local BH_VERSION_INFO = 1.04;
local NEWVERSION = false;

function BattleHerald_MainFrameLoad(self)

	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_ENTERING_BATTLEFIELD");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self:RegisterEvent("CHAT_MSG_ADDON");
	RegisterAddonMessagePrefix("BHVerInfo");

end

function BattleHerald_MainFrameEvent(self, event, ...)

	if (event == "CHAT_MSG_ADDON") then
		if (arg1 == "BHVerInfo") then
			BattleHerald_HandleVersionInfo(arg2, arg4, arg3);
		end
	elseif (event == "VARIABLES_LOADED") then
		BattleHerald_InitializeUserOptions();
		BattleHerald_CreateUserOptionsPanels();
		
		ChatFrame1:AddMessage("Battle Herald Loaded.");
	elseif (event == "PLAYER_ENTERING_WORLD") then
		if (IsInGuild()) then
			BattleHerald_PostVersionInfo("GUILD");
		end
	elseif (event == "PLAYER_ENTERING_BATTLEGROUND") then
		BattleHerald_PostVersionInfo("BATTLEGROUND");
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		if (GetRealNumRaidMembers() > 1) then
			BattleHerald_PostVersionInfo("RAID");
		elseif (GetRealNumPartyMembers() > 1) then
			BattleHerald_PostVersionInfo("PARTY");
		end
	end

end

function BattleHerald_IsInBattlefield()

	local zone = GetInstanceInfo();
	if (zone == "Warsong Gulch" or zone == "Arathi Basin"
	 or zone == "Alterac Valley" or zone == "Isle of Conquest"
	 or zone == "Eye of the Storm" or zone == "Strand of the Ancients"
	 or zone == "The Battle for Gilneas" or zone == "Twin Peaks") then
		return true;
	else
		zone = GetRealZoneText();
		if (zone == "Wintergrasp" or zone == "Tol Barad") then
			return true;
		else
			return false;
		end
	end

end

function BattleHerald_PostVersionInfo(channel, target)

	SendAddonMessage("BHVerInfo", BH_VERSION_INFO, channel, target);

end

function BattleHerald_HandleVersionInfo(msg, author, channel)
	
	local recNumber = tonumber(msg);
	
	if (recNumber > BH_VERSION_INFO) then
		if (not NEWVERSION) then
			NEWVERSION = true;
			DEFAULT_CHAT_FRAME:AddMessage(BHSTR_NEW_VERSION);
		end
	elseif (recNumber < BH_VERSION_INFO) then
		BattleHerald_PostVersionInfo("WHISPER", author);
	end
	
end
