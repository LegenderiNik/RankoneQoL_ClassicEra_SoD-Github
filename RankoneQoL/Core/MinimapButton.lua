-- ============================================================================
-- RankoneQoL - Minimap Button (Optimized & Cleaned)
-- ============================================================================

local L = RankoneQoL_Locals

local MinimapButton = CreateFrame("Button", "RankoneQoLMinimapButton", MinimapNavStruct or Minimap, "BackdropTemplate")
MinimapButton:SetSize(31, 31)
MinimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 1)
MinimapButton:SetToplevel(true)
MinimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

local background = MinimapButton:CreateTexture(nil, "BACKGROUND")
background:SetSize(20, 20)
background:SetPoint("CENTER", 0, 0)
background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")

local icon = MinimapButton:CreateTexture(nil, "ARTWORK")
icon:SetSize(20, 20)
icon:SetPoint("CENTER", 0, 0)
icon:SetTexture("Interface\\AddOns\\RankoneQoL\\logo")

local border = MinimapButton:CreateTexture(nil, "OVERLAY")
border:SetSize(53, 53)
border:SetPoint("TOPLEFT", 0, 0)
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

local function UpdateButtonPosition(angle)
    if not angle then angle = 45 end
    local radius = 80
    local x = math.cos(math.rad(angle)) * radius
    local y = math.sin(math.rad(angle)) * radius
    MinimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

MinimapButton:RegisterForDrag("LeftButton")
MinimapButton:SetScript("OnDragStart", function(self)
    self:LockHighlight()
    self:SetScript("OnUpdate", function()
        local xpos, ypos = GetCursorPosition()
        local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()
        local scale = Minimap:GetEffectiveScale()
        
        local x = xpos/scale - xmin - 70
        local y = ypos/scale - ymin - 70
        
        local angle = math.deg(math.atan2(y, x))
        if angle < 0 then angle = angle + 360 end
        
        if RankoneQoL_Profile then
            RankoneQoL_Profile.minimapPos = angle
        end
        UpdateButtonPosition(angle)
    end)
end)

MinimapButton:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
    self:UnlockHighlight()
end)

MinimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine(L["MINIMAP_TITLE"])
    GameTooltip:AddLine(L["MINIMAP_LEFT_CLICK"], 1, 1, 1)
    GameTooltip:AddLine(L["MINIMAP_RIGHT_CLICK"], 1, 1, 1)
    GameTooltip:AddLine(L["MINIMAP_DRAG"], 1, 1, 1)
    GameTooltip:Show()
end)

MinimapButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

MinimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
MinimapButton:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        if RankoneQoL_ToggleUI then RankoneQoL_ToggleUI() end
    elseif button == "RightButton" then
        C_UI.Reload()
    end
end)

local loadFrame = CreateFrame("Frame")
loadFrame:RegisterEvent("PLAYER_LOGIN")
loadFrame:SetScript("OnEvent", function()
    local currentPos = RankoneQoL_Profile and RankoneQoL_Profile.minimapPos or 45
    UpdateButtonPosition(currentPos)
end)
