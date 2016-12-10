BattleHerald_ScoreDelay = 300.0;
BattleHerald_NextScoreAlert = 0;	-- In seconds, when's the next score alert?
BattleHerald_ScoreElapsed = 0;

BattleHerald_ScoreModules = {
	["Arathi Basin"] = {
		GetAllianceScore = function()
			local _, state, _, text = GetWorldStateUIInfo(1);
			return tonumber(strsub(text, strfind(text, "Resources: ")+11, strfind(text, "/1600")-1));
		end,
		GetHordeScore = function()
			local _, state, _, text = GetWorldStateUIInfo(2);
			return tonumber(strsub(text, strfind(text, "Resources: ")+11, strfind(text, "/1600")-1));
		end,
		GetPointsSoundKeys = function()
			return "GENERAL", "RESOURCES";
		end,
		GetPointsText = function()
			return BHSTR_RESOURCES;
		end
	},
	["Alterac Valley"] = {
		GetAllianceScore = function()
			local _, state, _, text = GetWorldStateUIInfo(1);
			return tonumber(strsub(text, strfind(text, "Reinforcements: ")+16));
		end,
		GetHordeScore = function()
			local _, state, _, text = GetWorldStateUIInfo(2);
			return tonumber(strsub(text, strfind(text, "Reinforcements: ")+16));
		end,
		GetPointsSoundKeys = function()
			return "GENERAL", "REINFORCEMENTS";
		end,
		GetPointsText = function()
			return BHSTR_REINFORCEMENTS;
		end
	},
	["Isle of Conquest"] = {
		GetAllianceScore = function()
			local _, state, _, text = GetWorldStateUIInfo(1);
			return tonumber(strsub(text, strfind(text, "Reinforcements: ")+16));
		end,
		GetHordeScore = function()
			local _, state, _, text = GetWorldStateUIInfo(2);
			return tonumber(strsub(text, strfind(text, "Reinforcements: ")+16));
		end,
		GetPointsSoundKeys = function()
			return "GENERAL", "REINFORCEMENTS";
		end,
		GetPointsText = function()
			return BHSTR_REINFORCEMENTS;
		end
	},
	["The Battle for Gilneas"] = {
		GetAllianceScore = function()
			local _, state, _, text = GetWorldStateUIInfo(1);
			return tonumber(strsub(text, strfind(text, "Resources: ")+11, strfind(text, "/1600")-1));
		end,
		GetHordeScore = function()
			local _, state, _, text = GetWorldStateUIInfo(2);
			return tonumber(strsub(text, strfind(text, "Resources: ")+11, strfind(text, "/1600")-1));
		end,
		GetPointsSoundKeys = function()
			return "GENERAL", "RESOURCES";
		end,
		GetPointsText = function()
			return BHSTR_RESOURCES;
		end
	},
	["Eye of the Storm"] = {
		GetAllianceScore = function()
			local _, state, _, text = GetWorldStateUIInfo(2);
			return tonumber(strsub(text, strfind(text, "Victory Points: ")+16, strfind(text, "/1600")-1));
		end,
		GetHordeScore = function()
			local _, state, _, text = GetWorldStateUIInfo(3);
			return tonumber(strsub(text, strfind(text, "Victory Points: ")+16, strfind(text, "/1600")-1));
		end,
		GetPointsSoundKeys = function()
			return "GENERAL", "POINTS";
		end,
		GetPointsText = function()
			return BHSTR_POINTS;
		end
	}
}

function BattleHerald_InitializeScoreFrame()

	CreateFrame("Frame", "BattleHerald_ScoreMonitorFrame");
	BattleHerald_ScoreMonitorFrame:Hide();
	BattleHerald_ScoreMonitorFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
	BattleHerald_ScoreMonitorFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	BattleHerald_ScoreMonitorFrame:SetScript("OnEvent", BattleHerald_ScoreMonitorEvent);
	BattleHerald_ScoreMonitorFrame:SetScript("OnUpdate", BattleHerald_ScoreMonitorUpdate);

end

function BattleHerald_DoScoreAlert()

	-- TODO: Check for UserOption first!
	local zone = GetInstanceInfo();	
	local allyscore = BattleHerald_ScoreModules[zone]:GetAllianceScore();
	local hordescore = BattleHerald_ScoreModules[zone]:GetHordeScore();
	BattleHerald_AddSoundToQueueByKey("GENERAL", "ALLIANCE");
	BattleHerald_AddNumberToQueue(allyscore);
	BattleHerald_AddSoundToQueueByKey("GENERAL", "HORDE");
	BattleHerald_AddNumberToQueue(hordescore);
	
	-- TODO: AND AGAIN, CHECK FOR USEROPTION!
	local text = BHSTR_ALLIANCE .. ": " .. allyscore .. " - " .. BHSTR_HORDE .. ": " .. hordescore;
	BattleHerald_AddToTextQueue(text, "SCORE");

end

function BattleHerald_ScoreMonitorEvent(self, event, ...)

	if (event == "PLAYER_ENTERING_BATTLEGROUND") then
		local zone = GetInstanceInfo();
		if (BattleHerald_ScoreModules[zone]) then
			BattleHerald_ScoreElapsed = 0;
			BattleHerald_NextScoreAlert = BattleHerald_ScoreDelay;
			BattleHerald_ScoreMonitorFrame:Show();
		else
			-- The battleground doesn't have a score module!
			BattleHerald_ScoreMonitorFrame:Hide();
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		BattleHerald_ScoreMonitorFrame:Hide();
	end
	
end

function BattleHerald_ScoreMonitorUpdate(self, elapsed)

	BattleHerald_ScoreElapsed = BattleHerald_ScoreElapsed + elapsed;
	if (BattleHerald_ScoreElapsed >= BattleHerald_NextScoreAlert) then
		BattleHerald_DoScoreAlert();
		BattleHerald_NextScoreAlert = BattleHerald_NextScoreAlert + BattleHerald_ScoreDelay;
	end

end

BattleHerald_InitializeScoreFrame();