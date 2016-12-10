BH_NUM_MAX_TEXT_SLOTS = 4;
BH_NEUTRAL_STYLE = "NEUTRAL";
BH_SCORE_STYLE = "SCORE";
BH_ALLIANCE_STYLE = "ALLIANCE";
BH_HORDE_STYLE = "HORDE";
BH_TEXT_CONTAINER_TIMEOUT = 5.0;
local TYPEWRITER_COLOUR_ESCAPE = "|cFFBB88FF";
local BH_SEC_PER_CHAR = 0.015;
BattleHerald_NextTextSlot = 0;

BattleHerald_TextQueue = { };

function BattleHerald_GetTextSlot(no)

    return _G["BattleHerald_TextAlertContainer"..no];
    
end

function BattleHerald_TextCanDisplayNewline()

    for i = 0, BH_NUM_MAX_TEXT_SLOTS - 1 do
        if (BattleHerald_GetTextSlot(i).typewriter.anim:IsPlaying() and not BattleHerald_GetTextSlot(i).typewriter.anim:IsDone()) then
            return nil;
        end
    end
    
    return 1;

end

-- Returns left icon and right icon
function BattleHerald_GetStyleIcons(style)
	if (style == BH_ALLIANCE_STYLE) then
		return "Interface\\WorldStateFrame\\AllianceIcon.blp", "Interface\\WorldStateFrame\\AllianceIcon.blp";
	elseif (style == BH_HORDE_STYLE) then
		return "Interface\\WorldStateFrame\\HordeIcon.blp", "Interface\\WorldStateFrame\\HordeIcon.blp";
	elseif (style == BH_SCORE_STYLE) then
		return "Interface\\WorldStateFrame\\AllianceIcon.blp", "Interface\\WorldStateFrame\\HordeIcon.blp";
	else
		return nil, nil;
	end	
end

-- Raise the text containers except the specified one
function BattleHerald_RaiseTextContainers(except)

	local container;
	for i = 0, BH_NUM_MAX_TEXT_SLOTS - 1 do
		if (i ~= except) then
			container = BattleHerald_GetTextSlot(i);
			if (container:IsShown() and not container.fade:IsPlaying()) then
				BattleHerald_GetTextSlot(i).rise:Play();
			end
		end
	end
	
end

function BattleHerald_ProcessTextQueue()

    if (#BattleHerald_TextQueue == 0) then
        -- Nothing in the queue.
        return;
    end

    local container = BattleHerald_GetTextSlot(BattleHerald_NextTextSlot);
	local containerT = _G[container:GetName().."_Text"];
	local containerL = _G[container:GetName().."_LeftIcon"];
	local containerR = _G[container:GetName().."_RightIcon"];
    if (not container:IsShown() and BattleHerald_TextCanDisplayNewline()) then
        -- We've got an empty container.
        container.text = BattleHerald_TextQueue[1].text;
        container.style = BattleHerald_TextQueue[1].style;
		container.line = 1;
		container:SetAlpha(1.0);
		containerT:SetText("");
		-- Set the icons to show
		local left, right = BattleHerald_GetStyleIcons(BattleHerald_TextQueue[1].style);
		if (left) then
			containerL:Show();
			containerL:SetTexture(left);
		else
			containerL:Hide();
		end
		if (right) then
			containerR:Show();
			containerR:SetTexture(right);
		else
			containerR:Hide();
		end
		-- Set the typewriter duration
		container.typewriter.anim:SetDuration(strlen(container.text)*BH_SEC_PER_CHAR);
		-- Reset the position of the container
		container:ClearAllPoints();
		container:SetPoint("BOTTOM", container:GetParent(), "BOTTOM", 0, 0);
        
        if (container.style == BH_NEUTRAL_STYLE) then
			containerT:SetTextColor(1.0, 0.5, 0.25, 1.0);
		elseif (container.style == BH_ALLIANCE_STYLE) then
			containerT:SetTextColor(0.0, 0.7, 0.9, 1.0);
		else
			containerT:SetTextColor(1.0, 0.1, 0.1, 1.0);
		end
		
		container:Show();
		BattleHerald_RaiseTextContainers(BattleHerald_NextTextSlot);
		tremove(BattleHerald_TextQueue, 1);
		BattleHerald_NextTextSlot = (BattleHerald_NextTextSlot + 1) % BH_NUM_MAX_TEXT_SLOTS;
    end

end

function BattleHerald_AddToTextQueue(t, s)

    local temptable = { text = t, style = s };
    tinsert(BattleHerald_TextQueue, temptable);
	
	BattleHerald_ProcessTextQueue();
    
end

function BattleHerald_TypewriterAnimationUpdate(self, elapsed)

	local container = self:GetRegionParent();
	local progress = self:GetProgress();
	
	local charsToShow = floor(progress*strlen(container.text));
	-- We're typewriting it out
	_G[container:GetName().."_Text"]:SetText(strsub(container.text, 0, charsToShow));
			
end

function BattleHerald_TypewriterAnimationFinished(self)

	local container = self:GetRegionParent();
	_G[container:GetName().."_Text"]:SetText(container.text);
	
	BattleHerald_ProcessTextQueue();

end

function test()

	BattleHerald_AddToTextQueue("Neutral Print-out", "NEUTRAL");
	BattleHerald_AddToTextQueue("Alliance Print-out", "ALLIANCE");
	BattleHerald_AddToTextQueue("Horde Print-out", "HORDE");

end

function BattleHerald_Test()

	BattleHerald_AddToTextQueue("Hello there!", 0);

end