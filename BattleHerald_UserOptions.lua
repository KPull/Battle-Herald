--[[
BattleHerald_UserOptions.lua
Manages BattleHerald's User Options.
]]--

BattleHerald_UserOptionsClasses = { };

BattleHerald_UserOptionsClasses["Sound Alerts"] = {
	name = BHSTR_SOUND_ALERTS,
	description = BHSTR_SOUND_ALERTS_DESCRIPTION,
	options = {
		{ option = "WARSONG_GULCH_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_WARSONG_GULCH_ALERTS },
		--[[
		{ option = "WARSONG_GULCH_SCORES_SOUND", type = "bool", default = 1, adjacent = 1, label = BHSTR_WARSONG_GULCH_SCORES },
	    ]]--
		{ option = "ARATHI_BASIN_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_ARATHI_BASIN_ALERTS },
		{ option = "ALTERAC_VALLEY_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_ALTERAC_VALLEY_ALERTS },
		{ option = "EYE_OF_THE_STORM_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_EYE_OF_THE_STORM_ALERTS },
		{ option = "STRAND_OF_THE_ANCIENTS_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_STRAND_OF_THE_ANCIENTS_ALERTS },
		{ option = "ISLE_OF_CONQUEST_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_ISLE_OF_CONQUEST_ALERTS },
		{ option = "THE_BATTLE_FOR_GILNEAS_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_THE_BATTLE_FOR_GILNEAS_ALERTS },
		{ option = "TWIN_PEAKS_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_TWIN_PEAKS_ALERTS },
		--[[
		{ option = "TWIN_PEAKS_SCORES_SOUND", type = "bool", default = 1, adjacent = 1, label = BHSTR_TWIN_PEAKS_SCORES },
		]]--
		{ option = "WINTERGRASP_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_WINTERGRASP_ALERTS },
		{ option = "TOL_BARAD_ALERTS_SOUND", type = "bool", default = 1, label = BHSTR_TOL_BARAD_ALERTS }
	}
};

BattleHerald_UserOptionsClasses["Text Alerts"] = {
	name = BHSTR_TEXT_ALERTS,
	description = BHSTR_TEXT_ALERTS_DESCRIPTION,
	options = {
		{ option = "WARSONG_GULCH_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_WARSONG_GULCH_ALERTS },
		--[[
		{ option = "WARSONG_GULCH_SCORES_TEXT", type = "bool", default = 1, adjacent = 1, label = BHSTR_WARSONG_GULCH_SCORES },
		]]--
		{ option = "ARATHI_BASIN_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_ARATHI_BASIN_ALERTS },
		{ option = "ALTERAC_VALLEY_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_ALTERAC_VALLEY_ALERTS },
		{ option = "EYE_OF_THE_STORM_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_EYE_OF_THE_STORM_ALERTS },
		{ option = "STRAND_OF_THE_ANCIENTS_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_STRAND_OF_THE_ANCIENTS_ALERTS },
		{ option = "ISLE_OF_CONQUEST_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_ISLE_OF_CONQUEST_ALERTS },
		{ option = "THE_BATTLE_FOR_GILNEAS_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_THE_BATTLE_FOR_GILNEAS_ALERTS },
		{ option = "TWIN_PEAKS_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_TWIN_PEAKS_ALERTS },
		--[[
		{ option = "TWIN_PEAKS_SCORES_TEXT", type = "bool", default = 1, label = BHSTR_TWIN_PEAKS_SCORES },
		]]--
		{ option = "WINTERGRASP_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_WINTERGRASP_ALERTS },
		{ option = "TOL_BARAD_ALERTS_TEXT", type = "bool", default = 1, label = BHSTR_TOL_BARAD_ALERTS }
	}
};

BattleHerald_UserOptionsClasses["Battleground UI"] = {
	name = BHSTR_BATTLEGROUND_UI,
	description = BHSTR_BATTLEGROUND_UI_DESCRIPTION,
	options = {
	    { option = "WORLD_FRAME_SCALE", type = "slider", default = 100, min = 20, max = 120, label = BHSTR_WORLD_FRAME_UI_SCALE },
		{ option = "WARSONG_GULCH_UI", type = "bool", default = 1, label = BHSTR_WARSONG_GULCH_UI },
		{ option = "ARATHI_BASIN_UI", type = "bool", default = 1, label = BHSTR_ARATHI_BASIN_UI },
		{ option = "ALTERAC_VALLEY_UI", type = "bool", default = 1, label = BHSTR_ALTERAC_VALLEY_UI },
		{ option = "EYE_OF_THE_STORM_UI", type = "bool", default = 1, label = BHSTR_EYE_OF_THE_STORM_UI },
		{ option = "ISLE_OF_CONQUEST_UI", type = "bool", default = 1, label = BHSTR_ISLE_OF_CONQUEST_UI },
		{ option = "THE_BATTLE_FOR_GILNEAS_UI", type = "bool", default = 1, label = BHSTR_THE_BATTLE_FOR_GILNEAS_UI },
		{ option = "TWIN_PEAKS_UI", type = "bool", default = 1, label = BHSTR_TWIN_PEAKS_UI }
	}
};

-- Goes through the saved variables and sets up the user options
function BattleHerald_InitializeUserOptions()
	
	if (BattleHerald_UserOptions == nil) then
		BattleHerald_UserOptions = { };
	end
	
	for k, v in pairs(BattleHerald_UserOptionsClasses) do
		for i = 1, #v.options do
			if (BattleHerald_UserOptions[v.options[i].option] == nil) then
				-- Apply default
				BattleHerald_UserOptions[v.options[i].option] = v.options[i].default;
			end
		end
	end
	
end

-- Each panel's okay function
function BattleHerald_UserOptionsPanelOkay(self)

	local v;
	for i = 1, #BattleHerald_UserOptionsClasses[self.optionsgroup].options do
		v = BattleHerald_UserOptionsClasses[self.optionsgroup].options[i];
		if (v.type == "bool") then
			if (v.control:GetChecked()) then
				BattleHerald_UserOptions[v.option] = 1;
			else
				BattleHerald_UserOptions[v.option] = 0;
			end
		elseif (v.type == "slider") then
		    BattleHerald_UserOptions[v.option] = v.control:GetValue();
		end
		if (v.callback) then
		    v.callback(v.option, BattleHerald_UserOptions[v.option]);
		end
	end

end

-- Each panel's cancel function
function BattleHerald_UserOptionsPanelCancel(self)

	local v;
	for i = 1, #BattleHerald_UserOptionsClasses[self.optionsgroup].options do
		v = BattleHerald_UserOptionsClasses[self.optionsgroup].options[i];
		if (v.type == "bool") then
			v.control:SetChecked(BattleHerald_UserOptions[v.option]);
		elseif (v.type == "slider") then
		    v.control:SetValue(BattleHerald_UserOptions[v.option]);
		end
	end

end

-- Each panel's refresh function
function BattleHerald_UserOptionsPanelRefresh(self)

	local v;
	for i = 1, #BattleHerald_UserOptionsClasses[self.optionsgroup].options do
		v = BattleHerald_UserOptionsClasses[self.optionsgroup].options[i];
		if (v.type == "bool") then
			v.control:SetChecked(BattleHerald_UserOptions[v.option]);
		elseif (v.type == "slider") then
		    v.control:SetValue(BattleHerald_UserOptions[v.option]);
		end
	end

end

-- Each panel's refresh function
function BattleHerald_UserOptionsPanelDefault(self)

	local v;
	for i = 1, #BattleHerald_UserOptionsClasses[self.optionsgroup].options do
		v = BattleHerald_UserOptionsClasses[self.optionsgroup].options[i];
		if (v.type == "bool") then
			BattleHerald_UserOptions[v.option] = v.default;
			v.control:SetChecked(v.default);
		elseif (v.type == "slider") then
		    BattleHerald_UserOptions[v.option] = v.default;
		    v.control:SetValue(v.default);
		end
		if (v.callback) then
		    v.callback(v.option, BattleHerald_UserOptions[v.option]);
		end
	end

end

-- Creates the Interface Options panels
function BattleHerald_CreateUserOptionsPanels()

	local panel, title, subtitle, curr, prev;
	local x, y;
	
	-- First create the Battle Herald category
	panel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer);
	panel.name = BHSTR_BATTLE_HERALD;
	InterfaceOptions_AddCategory(panel);
	
	for k, v in pairs(BattleHerald_UserOptionsClasses) do
		-- Create the panel object
		panel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer);
		panel.name = v.name;
		panel.parent = BHSTR_BATTLE_HERALD;
		panel.optionsgroup = k;
		panel.okay = BattleHerald_UserOptionsPanelOkay;
		panel.cancel = BattleHerald_UserOptionsPanelCancel;
		panel.default = BattleHerald_UserOptionsPanelDefault;
		panel.refresh = BattleHerald_UserOptionsPanelRefresh;
		
		-- Create the title string
		title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
		title:SetJustifyH("LEFT");
		title:SetJustifyV("TOP");
		title:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -16);
		title:SetText(v.name);
		
		-- Create the subtitle string
		subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
		subtitle:SetJustifyH("LEFT");
		subtitle:SetJustifyV("TOP");
		subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8);
		subtitle:SetPoint("RIGHT", panel, "RIGHT", -32, 0);
		subtitle:SetNonSpaceWrap(true);
		subtitle:SetText(v.description);
		
		prev = nil;
		
		for i = 1, #v.options do
			if (v.options[i].type == "bool") then
				-- It's a bool. Create a check mark.
				curr = CreateFrame("CheckButton", "BattleHerald_"..v.options[i].option.."_CheckButton", panel, "InterfaceOptionsCheckButtonTemplate");
				_G[curr:GetName().."Text"]:SetText(v.options[i].label);
				curr:SetChecked(v.options[i].default);
			elseif (v.options[i].type == "slider") then
			    -- It's a slider. Create it.
			    curr = CreateFrame("Slider", "BattleHerald_"..v.options[i].option.."_Slider", panel, "OptionsSliderTemplate");
			    _G[curr:GetName().."Text"]:SetText(v.options[i].label);
			    _G[curr:GetName().."Low"]:SetText(v.options[i].min);
			    _G[curr:GetName().."High"]:SetText(v.options[i].max);
			    curr:SetMinMaxValues(v.options[i].min, v.options[i].max);
			    curr:SetValue(v.options[i].default);
			end
			if (prev == nil) then
				-- First control in the panel
				curr:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -18);
			else
				if (v.options[i].adjacent) then
					-- We need to place it adjacent to the previous control.
					curr:SetPoint("TOPLEFT", prev, "TOPLEFT", 200, 0);
				else
					-- Place it under previous control
					curr:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -8);
				end
			end
			
			-- Keep a reference to the widget in the UserOptionsClasses table
			v.options[i].control = curr;
			if (not v.options[i].adjacent) then
				prev = curr;
			end
			
		end
		
		-- Add the panel to the Interface Options frame
		InterfaceOptions_AddCategory(panel);
	end

end

-- Each option may take a single function
-- which is called when its value is changed.
-- The handler will be passed the option name as well as the new value
function BattleHerald_RegisterOptionHandler(cat, option, func)

    assert(BattleHerald_UserOptionsClasses[cat], "The specified user options category could not be found.");

    for i = 1, #BattleHerald_UserOptionsClasses[cat].options do
        if (BattleHerald_UserOptionsClasses[cat].options[i].option == option) then
            BattleHerald_UserOptionsClasses[cat].options[i].callback = func;
			return;
        end
    end
    
    error("Could not find the specified user option.");
    
end

function BattleHerald_GetUserOption(option)

	if (BattleHerald_UserOptions and BattleHerald_UserOptions[option]) then
		return BattleHerald_UserOptions[option];
	else
		return nil;
	end

end
