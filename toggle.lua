local dataobj = LibStub('LibDataBroker-1.1'):NewDataObject('AutoLootBroker', {type = 'launcher',text = ''})
local f = CreateFrame'Frame'
local ON = 'Loot: |cff00ff00ON|r'
local OFF = 'Loot: |cffff0000OFF|r'
local already_in_group = false

local function toggleAutoLoot(switch)
    if(switch) then
        _G.SetCVar('autoLootDefault', '1')
        dataobj.text = ON
        dataobj.icon = 'Interface\\Icons\\INV_Misc_Bag_07_Green'
    else
        _G.SetCVar('autoLootDefault', '0')
        dataobj.text = OFF
        dataobj.icon = 'Interface\\Icons\\INV_Misc_Bag_07_Red'
    end
end

local function Update()
end

f.GROUP_ROSTER_UPDATE = function()
    local new_state = IsInGroup()
    if(new_state ~= already_in_group) then
        already_in_group = new_state
        toggleAutoLoot(not new_state)
    end
end

function f:PLAYER_LOGIN()
    self.PLAYER_LOGIN = nil
    f:RegisterEvent'GROUP_ROSTER_UPDATE'
    return self:GROUP_ROSTER_UPDATE()
end

function dataobj.OnClick()
    if _G.GetCVar('autoLootDefault') == '0' then
        TurnOn()
    elseif _G.GetCVar('autoLootDefault') == '1' then
        TurnOFF()
    end
end

function dataobj.OnTooltipShow(tooltip)
    if not tooltip or not tooltip.AddLine then return end

    local status
    if _G.GetCVar('autoLootDefault') == '1' then
        status = true
    end
    tooltip:AddDoubleLine('|cffff8800AutoLootToggle|r', status and '|cff00ff00ON|r' or '|cffff0000OFF|r')
end

f:RegisterEvent'PLAYER_LOGIN'
f:SetScript('OnEvent', function(self, event, ...) self[event](self, event, ...) end)


