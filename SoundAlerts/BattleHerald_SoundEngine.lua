BattleHerald_SoundQueue = { };
BattleHerald_MaxSoundElapsed = 0;
BattleHerald_SoundElapsed = 0;

function BattleHerald_InitializeSoundQueueFrame()

	local frame = CreateFrame("Frame");
	frame:SetScript("OnUpdate", BattleHerald_UpdateSoundEngine);
	frame:Show();

end

function BattleHerald_AddSoundToQueue(file, length)
	tinsert(BattleHerald_SoundQueue, {["file"] = file, ["length"] = length});
end

function BattleHerald_AddSoundToQueueByKey(key1, key2)
	if (not BattleHerald_SoundList[key1] or not BattleHerald_SoundList[key1][key2]) then
		return;
	end
	BattleHerald_AddSoundToQueue("Interface\\AddOns\\BattleHerald\\SoundAlerts\\SOUNDS\\" .. BattleHerald_SoundList[key1][key2]["DEFAULT_EN"].file, BattleHerald_SoundList[key1][key2]["DEFAULT_EN"].length);
end

function BattleHerald_AddNumberToQueue(num)
	-- NOTE: NUM_0 doesn't exist. So it simply ignores it.
	
	local units = 1000;
	local result;
	
	-- Do thousands
	result = floor(num / units);
	BattleHerald_AddSoundToQueueByKey("GENERAL", "NUM_" .. (result*units));
	num = num % units;
	units = units / 10;
	
	-- Do hundreds
	result = floor(num / units);
	BattleHerald_AddSoundToQueueByKey("GENERAL", "NUM_" .. (result*units));
	num = num % units;
	units = units / 10;
	
	-- Check whether it's from 11 to 19;
	-- otherwise, continue normally
	if (num >= 11 and num <= 19) then
		BattleHerald_AddSoundToQueueByKey("GENERAL", "NUM_" .. num);
		return;
	end
	
	-- Do tens
	result = floor(num / units);
	BattleHerald_AddSoundToQueueByKey("GENERAL", "NUM_" .. (result*units));
	num = num % units;
	units = units / 10;
	
	-- Do ones
	BattleHerald_AddSoundToQueueByKey("GENERAL", "NUM_" .. result);
	
end

function BattleHerald_AdvanceQueue()
	PlaySoundFile(BattleHerald_SoundQueue[1].file);
	BattleHerald_MaxSoundElapsed = BattleHerald_SoundQueue[1].length;
	BattleHerald_SoundElapsed = 0;
	
	tremove(BattleHerald_SoundQueue, 1);
end

function BattleHerald_UpdateSoundEngine(self, elapsed)
	BattleHerald_SoundElapsed = BattleHerald_SoundElapsed + elapsed;
	if ((BattleHerald_SoundElapsed > BattleHerald_MaxSoundElapsed) and (#BattleHerald_SoundQueue > 0)) then
		BattleHerald_AdvanceQueue();
	end
end

BattleHerald_InitializeSoundQueueFrame();
