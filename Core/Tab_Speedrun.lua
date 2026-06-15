-- ============================================================================
-- RankoneQoL - Interface Tab: Speedrun (Cleaned & Optimized)
-- ============================================================================

local L = RankoneQoL_Locals

-- 1. TAB & PANEL IM GEHÄUSE REGISTRIEREN
local speedrunTab = RankoneQoL_CreateVectorTab("SPEEDRUN", L["TAB_SPEEDRUN"], -75, false)
if speedrunTab then 
    speedrunTab:SetSize(130, 24) 
    if speedrunTab.glowBar then speedrunTab.glowBar:SetSize(2, 22) end 
end
local speedrunPanel = RankoneQoL_CreateContentPanel("SPEEDRUN")

-- ============================================================================
-- 2. HILFSFUNKTION FÜR DIE SUB-KACHELN (VOLLE BREITE)
-- ============================================================================
local function CreateSubCard(name, titleText, x, y, width, height)
    local baseFrame = RankoneQoL_GetMainFrame()
    local card = CreateFrame("Frame", "RankoneQoLCard_"..name, speedrunPanel, "BackdropTemplate")
    card:SetSize(width, height)
    card:SetPoint("TOPLEFT", baseFrame, "TOPLEFT", x, y)
    card:SetFrameLevel(baseFrame:GetFrameLevel() + 2)
    
    card:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile = true, tileSize = 16, edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    card:SetBackdropColor(0.04, 0.04, 0.04, 0.85)
    card:SetBackdropBorderColor(0.15, 0.15, 0.15, 0.9)
    
    local title = card:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    title:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -12)
    title:SetText("|cFF00C0FF" .. titleText .. "|r")
    RankoneQoL_RegisterFontString(title)
    
    return card
end

-- ============================================================================
-- 3. HILFSFUNKTION FÜR GRID-CHECKBOXEN (Baut auf globalen Skin auf)
-- ============================================================================
local function CreateGridCheckbox(name, label, tooltipText, xOffset, yOffset, dbKey, parentCard)
    local cb = CreateFrame("CheckButton", "RankoneQoLGridUI_"..name, parentCard, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", parentCard, "TOPLEFT", xOffset, yOffset)
    cb:SetSize(18, 18)
    cb:SetFrameLevel(parentCard:GetFrameLevel() + 1)
    
    local cbLabel = _G[cb:GetName() .. "Text"]
    cbLabel:SetText(label)
    cbLabel:SetPoint("LEFT", cb, "RIGHT", 10, 0)
    
    if RankoneQoL_RegisterFontString then
        RankoneQoL_RegisterFontString(cbLabel)
    end
    
    local checkTex = cb:GetCheckedTexture()
    if checkTex then 
        checkTex:SetVertexColor(0.0, 0.9, 0.7, 1.0)
    end
    
    -- OnEnter: Ruft nur noch Blizzards Standard auf – unser globales Modul färbt es um!
    cb:SetScript("OnEnter", function(self)
        if tooltipText and tooltipText ~= "" then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(label, 0.0, 0.75, 1.0) -- Überschrift in deinem Sci-Fi Cyan
            GameTooltip:AddLine(tooltipText, 0.8, 0.8, 0.8, true)
            GameTooltip:Show()
        end
    end)
    
    cb:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    cb:SetScript("OnShow", function(self) 
        if RankoneQoL_Profile and RankoneQoL_Profile[dbKey] ~= nil then
            self:SetChecked(RankoneQoL_Profile[dbKey]) 
        else
            self:SetChecked(false)
        end
    end)
    
    cb:SetScript("OnClick", function(self)
        if RankoneQoL_Profile then
            RankoneQoL_Profile[dbKey] = self:GetChecked()
        end
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    end)
    
    return cb
end

-- ============================================================================
-- 4. GEOMETRIE-POSITIONIERUNG
-- ============================================================================
local speedrunCard = CreateSubCard("SpeedrunOps", L["CARD_SPEEDRUN_OPS"], 165, -45, 420, 150)

CreateGridCheckbox("SpeedFlight", L["OPT_SPEED_FLIGHT"], L["TT_SPEED_FLIGHT"], 16, -40, "speedFlight", speedrunCard)
CreateGridCheckbox("SpeedHearth", L["OPT_SPEED_HEARTH"], L["TT_SPEED_HEARTH"], 16, -75, "speedHearth", speedrunCard)
CreateGridCheckbox("SpeedGossip", L["OPT_SPEED_GOSSIP"], L["TT_SPEED_GOSSIP"], 16, -110, "speedGossip", speedrunCard)
