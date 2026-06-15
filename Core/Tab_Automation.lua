-- ============================================================================
-- RankoneQoL - Interface Tab: Automation (Perfektes Untereinander-Layout)
-- ============================================================================

local L = RankoneQoL_Locals

-- 1. TAB & PANEL IM GEHÄUSE REGISTRIEREN
-- FIX: Größe 130x24 erzwungen und den Leuchtstreifen auf 22px verkleinert!
local automationTab = RankoneQoL_CreateVectorTab("AUTOMATION", L["TAB_AUTOMATION"], -45, false)
if automationTab then 
    automationTab:SetSize(130, 24) 
    if automationTab.glowBar then automationTab.glowBar:SetSize(2, 22) end 
end
local automationPanel = RankoneQoL_CreateContentPanel("AUTOMATION")

-- ============================================================================
-- 2. HILFSFUNKTION FÜR DIE SUB-KACHELN (VOLLE BREITE)
-- ============================================================================
local function CreateSubCard(name, titleText, x, y, width, height)
    local baseFrame = RankoneQoL_GetMainFrame()
    local card = CreateFrame("Frame", "RankoneQoLCard_"..name, automationPanel, "BackdropTemplate")
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
-- 3. HILFSFUNKTION FÜR GRID-CHECKBOXEN
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
    
    cb.tooltipText = tooltipText
    
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

-- OBERE KACHEL: Merchant Operations
local merchantCard = CreateSubCard("Merchant", "MERCHANT OPERATIONS", 165, -45, 420, 115)
CreateGridCheckbox("AutoSell", L["OPT_AUTO_SELL"], L["TT_AUTO_SELL"], 16, -40, "autoSell", merchantCard)
CreateGridCheckbox("AutoRepair", L["OPT_AUTO_REPAIR"], L["TT_AUTO_REPAIR"], 16, -75, "autoRepair", merchantCard)

-- UNTERE KACHEL: World Operations
local worldCard = CreateSubCard("World", "WORLD OPERATIONS", 165, -170, 420, 115)
CreateGridCheckbox("AutoQuest", L["OPT_AUTO_QUEST"], L["TT_AUTO_QUEST"], 16, -40, "autoQuest", worldCard)
CreateGridCheckbox("AutoLoot", L["OPT_AUTO_LOOT"], L["TT_AUTO_LOOT"], 16, -75, "autoLoot", worldCard)
