-- Add slash command handlers in this function for the /bh or /battleherald commands
BattleHerald_SlashCommands = { }

function BattleHerald_HandleSlashCommand(msg)

	if (BattleHerald_SlashCommands[msg]) then
		BattleHerald_SlashCommands[msg](msg);
	end

end

SlashCmdList["BATTLE_HERALD"] = BattleHerald_HandleSlashCommand;
SLASH_BATTLE_HERALD1 = "/bh";
SLASH_BATTLE_HERALD2 = "/battleherald";