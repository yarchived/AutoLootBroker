
local dataobj = LibStub('LibDataBroker-1.1'):NewDataObject('AutoLootBroker', {
    type = 'launcher',
    icon = 'Interface\\Icons\\INV_Misc_Bag_07_Green',
    text = 'Loot: ...'
})

local f = CreateFrame'Frame'
local ON = 'Loot: |cff00ff00ON|r'
local OFF = 'Loot: |cffff0000OFF|r'

local function setState(switch)
    if(switch) then
        dataobj.text = ON
        dataobj.icon = 'Interface\\Icons\\INV_Misc_Bag_07_Green'
    else
        dataobj.text = OFF
        dataobj.icon = 'Interface\\Icons\\INV_Misc_Bag_07_Red'
    end
end

local function toggleAutoLoot(switch)
    if(switch) then
        SetCVar('autoLootDefault', '1')
    else
        SetCVar('autoLootDefault', '0')
    end
    return setState(switch)
end

local function isAutoLootOn()
    return _G.GetCVar('autoLootDefault') == '1' 
end

local already_in_group = false
f.GROUP_ROSTER_UPDATE = function()
    local new_state = IsInGroup()
    if(new_state ~= already_in_group) then
        already_in_group = new_state
        toggleAutoLoot(not new_state)
    end
end

function f:PLAYER_LOGIN()
    setState(isAutoLootOn())
    self.PLAYER_LOGIN = nil
    f:RegisterEvent'GROUP_ROSTER_UPDATE'
    return self:GROUP_ROSTER_UPDATE()
end

function dataobj.OnClick()
    local isOn = isAutoLootOn()
    if(isOn) then
        toggleAutoLoot(false)
    else
        toggleAutoLoot(true)
    end
end

function dataobj.OnTooltipShow(tooltip)
    local status
    if(isAutoLootOn()) then
        status = true
    end
    tooltip:AddDoubleLine('|cffff8800AutoLootToggle|r', status and '|cff00ff00ON|r' or '|cffff0000OFF|r')
end

f:RegisterEvent'PLAYER_LOGIN'
f:SetScript('OnEvent', function(self, event, ...) self[event](self, event, ...) end)

