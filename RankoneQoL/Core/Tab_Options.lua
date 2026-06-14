-- ============================================================================
-- RankoneQoL - Interface Tab: Options & System Controls (Cleaned Profile Management)
-- ============================================================================

local L = RankoneQoL_Locals
local MainFrame = RankoneQoL_GetMainFrame()

-- 1. TAB & PANEL IM GEHÄUSE REGISTRIEREN
local optionsTab = RankoneQoL_CreateVectorTab("OPTIONS", L["TAB_OPTIONS"], 80, true)
if optionsTab then 
    optionsTab:SetSize(130, 24) 
    if optionsTab.glowBar then optionsTab.glowBar:SetSize(2, 22) end 
end
local optionsPanel = RankoneQoL_CreateContentPanel("OPTIONS")

-- ============================================================================
-- 2. HILFSFUNKTION FÜR STRUKTURIERTE HORIZONTALE KACHELN
-- ============================================================================
local function CreateSubCard(name, titleText, x, y, width, height)
    local baseFrame = RankoneQoL_GetMainFrame()
    local card = CreateFrame("Frame", "RankoneQoLOptionsCard_"..name, optionsPanel, "BackdropTemplate")
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
-- 3. KACHEL: PROFILE MANAGEMENT (Zurückgesetzt auf Position -45)
-- ============================================================================
local profileCard = CreateSubCard("ProfileManagement", "PROFILE MANAGEMENT", 165, -45, 420, 115)

-- A) AKTIVES CHARAKTERPROFIL ANZEIGEN (Mit Klassenfarbe)
local currentProfileLabel = profileCard:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
currentProfileLabel:SetPoint("TOPLEFT", profileCard, "TOPLEFT", 14, -42)
local currentProfileLabelTitle = profileCard:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
currentProfileLabelTitle:SetPoint("BOTTOMLEFT", currentProfileLabel, "TOPLEFT", 0, 4)
currentProfileLabelTitle:SetText("|cFFFFFFFFActive Profile:|r")
RankoneQoL_RegisterFontString(currentProfileLabelTitle)

local currentName, currentServer = UnitFullName("player")
local currentKey = currentName .. " - " .. (currentServer or GetRealmName())
local _, classFilename = UnitClass("player")
local classColorHex = "FF00C0FF"

if classFilename and RAID_CLASS_COLORS[classFilename] then
    classColorHex = RAID_CLASS_COLORS[classFilename].colorStr
end

currentProfileLabel:SetText("|c" .. classColorHex .. currentKey .. "|r")
RankoneQoL_RegisterFontString(currentProfileLabel)

-- B) PROFIL-KOPIERER DROPDOWN (Mit Duplikat-Filter)
local profileLabel = profileCard:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
profileLabel:SetPoint("TOPLEFT", profileCard, "TOPLEFT", 215, -20)
profileLabel:SetText(L["LABEL_COPY_PROFILE"])
RankoneQoL_RegisterFontString(profileLabel)

local profileDropBtn = CreateFrame("Button", "RankoneQoLProfileDropButton", profileCard, "BackdropTemplate")
profileDropBtn:SetSize(190, 24)
profileDropBtn:SetPoint("TOPLEFT", profileCard, "TOPLEFT", 215, -38)
profileDropBtn:SetFrameLevel(profileCard:GetFrameLevel() + 1)
profileDropBtn:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
profileDropBtn:SetBackdropColor(0.04, 0.04, 0.04, 0.9)
profileDropBtn:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)

local profileDropTxt = profileDropBtn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
profileDropTxt:SetPoint("LEFT", profileDropBtn, "LEFT", 8, 0)
RankoneQoL_RegisterFontString(profileDropTxt)

profileDropBtn:SetScript("OnShow", function()
    if RankoneQoL_Profile and RankoneQoL_Profile.lastImportedFrom then profileDropTxt:SetText(RankoneQoL_Profile.lastImportedFrom) else profileDropTxt:SetText(L["DROP_SELECT_PROFILE"]) end
end)

local profileDropArrow = profileDropBtn:CreateTexture(nil, "OVERLAY")
profileDropArrow:SetSize(12, 12)
profileDropArrow:SetPoint("RIGHT", profileDropBtn, "RIGHT", -8, -4)
profileDropArrow:SetTexture("Interface\\Calendar\\MoreArrow")
profileDropArrow:SetVertexColor(0.0, 0.75, 1.0, 1.0)

local profileDropList = CreateFrame("Frame", "RankoneQoL_ProfileList", profileCard, "BackdropTemplate")
profileDropList:SetSize(190, 92)
profileDropList:SetPoint("TOPLEFT", profileDropBtn, "BOTTOMLEFT", 0, -2)
profileDropList:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
profileDropList:SetBackdropColor(0.02, 0.02, 0.02, 0.96)
profileDropList:SetBackdropBorderColor(0.12, 0.12, 0.12, 0.8)
profileDropList:Hide()
profileDropList:SetFrameLevel(MainFrame:GetFrameLevel() + 5)

local profileScrollOffset = 0
local profileButtons = {}
local availableProfiles = {}

local function UpdateProfileDropdownItems()
    table.wipe(availableProfiles)
    local seenCleanKeys = {}
    
    if RankoneQoL_DB and RankoneQoL_DB.profiles then
        for k, _ in pairs(RankoneQoL_DB.profiles) do
            if k ~= currentKey and k ~= "Default" then
                local cleanKey = string.gsub(string.lower(k), "%s", "")
                cleanKey = string.gsub(cleanKey, "%-", "")
                
                if not seenCleanKeys[cleanKey] then
                    seenCleanKeys[cleanKey] = true
                    table.insert(availableProfiles, k)
                end
            end
        end
    end
    
    local totalProfiles = #availableProfiles
    for i = 1, 4 do
        local profIndex = i + profileScrollOffset
        local btn = profileButtons[i]
        if profIndex <= totalProfiles then btn.text:SetText(availableProfiles[profIndex]) btn.targetProfileKey = availableProfiles[profIndex] btn:Show() else btn:Hide() end
    end
end

for i = 1, 4 do
    local btn = CreateFrame("Button", nil, profileDropList, "BackdropTemplate")
    btn:SetSize(188, 22)
    btn:SetPoint("TOPLEFT", profileDropList, "TOPLEFT", 1, -((i-1)*22) - 4)
    btn:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground"})
    btn:SetBackdropColor(0, 0, 0, 0)
    btn.text = btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    btn.text:SetPoint("LEFT", btn, "LEFT", 10, 0)
    RankoneQoL_RegisterFontString(btn.text)
    btn:SetScript("OnEnter", function(self) self:SetBackdropColor(0.0, 0.4, 0.6, 0.2) end)
    btn:SetScript("OnLeave", function(self) self:SetBackdropColor(0, 0, 0, 0) end)
    btn:SetScript("OnClick", function(self)
        local source = RankoneQoL_DB.profiles[self.targetProfileKey]
        if source then
            local savedImportKey = self.targetProfileKey
            RankoneQoL_Profile.autoSell = source.autoSell
            RankoneQoL_Profile.autoRepair = source.autoRepair
            RankoneQoL_Profile.autoQuest = source.autoQuest
            RankoneQoL_Profile.autoLoot = source.autoLoot
            RankoneQoL_Profile.autoCinematic = source.autoCinematic
            RankoneQoL_Profile.speedFlight = source.speedFlight
            RankoneQoL_Profile.speedHearth = source.speedHearth
            RankoneQoL_Profile.speedGossip = source.speedGossip
            RankoneQoL_Profile.tooltipScale = source.tooltipScale
            RankoneQoL_Profile.menuTheme = source.menuTheme
            RankoneQoL_Profile.menuFont = source.menuFont
            RankoneQoL_Profile.menuFontSize = source.menuFontSize
            RankoneQoL_Profile.lastImportedFrom = savedImportKey
            profileDropTxt:SetText(savedImportKey)
            print(string.format(L["CHAT_PROFILE_COPIED"], savedImportKey))
            profileDropList:Hide() 
            C_UI.Reload()
        end
    end)
    profileButtons[i] = btn
end

profileDropList:SetScript("OnMouseWheel", function(self, delta)
    local maxOffset = #availableProfiles - 4
    if maxOffset > 0 then
        if delta > 0 then profileScrollOffset = math.max(0, profileScrollOffset - 1) else profileScrollOffset = math.min(maxOffset, profileScrollOffset + 1) end
        UpdateProfileDropdownItems()
    end
end)

profileDropBtn:SetScript("OnClick", function()
    if profileDropList:IsShown() then profileDropList:Hide() else profileScrollOffset = 0 profileDropList:Show() UpdateProfileDropdownItems() end
end)

-- 4. SYSTEM BUTTONS (RELOAD UI UNTEN LINKS)
local reloadBtn = CreateFrame("Button", "RankoneQoLReloadButton", MainFrame, "BackdropTemplate")
reloadBtn:SetSize(130, 24)
reloadBtn:SetPoint("BOTTOMLEFT", MainFrame, "BOTTOMLEFT", 12, 16)
reloadBtn:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
reloadBtn:SetBackdropColor(0.14, 0.04, 0.04, 0.5)
reloadBtn:SetBackdropBorderColor(0.22, 0.08, 0.08, 0.8)

local btnText = reloadBtn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
btnText:SetPoint("CENTER", 0, 0)
btnText:SetText(L["RELOAD_UI"])
reloadBtn.text = btnText
RankoneQoL_RegisterFontString(btnText)

reloadBtn:SetScript("OnEnter", function(self) self:SetBackdropColor(0.24, 0.06, 0.06, 0.85) self:SetBackdropBorderColor(0.45, 0.12, 0.12, 1.0) self.text:SetTextColor(1, 0.8, 0.8, 1) end)
reloadBtn:SetScript("OnLeave", function(self) self:SetBackdropColor(0.14, 0.04, 0.04, 0.5) self:SetBackdropBorderColor(0.22, 0.08, 0.08, 0.8) self.text:SetTextColor(0.0, 0.75, 1.0, 1.0) end)
reloadBtn:SetScript("OnClick", function() C_UI.Reload() end)
