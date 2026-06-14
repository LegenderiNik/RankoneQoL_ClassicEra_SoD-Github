-- ============================================================================
-- RankoneQoL - Interface Tab: Changelog (Dynamic Auto-Height Scroll Engine)
-- ============================================================================

local L = RankoneQoL_Locals
local MainFrame = RankoneQoL_GetMainFrame()

-- 1. TAB & PANEL IM GEHÄUSE REGISTRIEREN
local changelogTab = RankoneQoL_CreateVectorTab("CHANGELOG", L["TAB_CHANGELOG"], 48, true)
if changelogTab then 
    changelogTab:SetSize(130, 24) 
    if changelogTab.glowBar then changelogTab.glowBar:SetSize(2, 22) end 
end
local changelogPanel = RankoneQoL_CreateContentPanel("CHANGELOG")

-- ============================================================================
-- 2. HAUPTKACHEL ERSTELLEN
-- ============================================================================
local card = CreateFrame("Frame", "RankoneQoLCard_Changelog", changelogPanel, "BackdropTemplate")
card:SetSize(420, 240)
card:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 165, -45)
card:SetFrameLevel(MainFrame:GetFrameLevel() + 2)

card:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile = true, tileSize = 16, edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
})
card:SetBackdropColor(0.04, 0.04, 0.04, 0.85)
card:SetBackdropBorderColor(0.15, 0.15, 0.15, 0.9)

-- ============================================================================
-- 3. SCROLL-GEHÄUSE INITIALISIEREN
-- ============================================================================
local scrollFrame = CreateFrame("ScrollFrame", "RankoneQoLChangelogScrollFrame", card)
scrollFrame:SetSize(360, 212)
scrollFrame:SetPoint("TOPLEFT", card, "TOPLEFT", 14, -14)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
-- Startet mit einer Standard-Größe, wird gleich dynamisch überschrieben
scrollChild:SetSize(360, 212) 
scrollFrame:SetScrollChild(scrollChild)

local textContainer = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
textContainer:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0)
textContainer:SetWidth(360)
textContainer:SetJustifyH("LEFT")
textContainer:SetJustifyV("TOP")
textContainer:SetSpacing(5) 
textContainer:SetText(RankoneQoL_ChangelogText or "Kein Changelog vorhanden.")

if RankoneQoL_RegisterFontString then
    RankoneQoL_RegisterFontString(textContainer)
end

-- ============================================================================
-- 4. SCI-FI SCROLLBAR DESIGN
-- ============================================================================
local customScrollBar = CreateFrame("Frame", nil, card, "BackdropTemplate")
customScrollBar:SetSize(6, 212)
customScrollBar:SetPoint("RIGHT", card, "RIGHT", -10, 0)
customScrollBar:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
})
customScrollBar:SetBackdropColor(0.08, 0.08, 0.08, 1)
customScrollBar:SetBackdropBorderColor(0.16, 0.16, 0.16, 0.6)

local customThumb = customScrollBar:CreateTexture(nil, "OVERLAY")
customThumb:SetSize(6, 40) 
customThumb:SetColorTexture(0.0, 0.75, 1.0, 0.75)
customThumb:SetPoint("TOP", customScrollBar, "TOP", 0, 0)

-- Dynamische Werte, die erst berechnet werden können, sobald das UI gezeichnet wird
local maxScroll = 0
local currentScrollOffset = 0

local function UpdateScrollPosition()
    if maxScroll <= 0 then return end
    scrollFrame:SetVerticalScroll(currentScrollOffset)
    local progress = currentScrollOffset / maxScroll
    local maxThumbPath = 212 - 40
    customThumb:SetPoint("TOP", customScrollBar, "TOP", 0, -(progress * maxThumbPath))
end

-- ============================================================================
-- 5. THE DYNAMIC AUTO-HEIGHT CALCULATOR ENGINE
-- ============================================================================
card:SetScript("OnShow", function()
    -- Holt die exakte, gerenderte Texthöhe in Pixeln direkt aus der WoW-Engine
    local realTextHeight = textContainer:GetStringHeight()
    
    -- Verpasst dem Gehäuse die dynamische Höhe plus 25 Pixel Puffer für das edle Design
    local calculatedChildHeight = math.max(212, realTextHeight + 25)
    scrollChild:SetSize(360, calculatedChildHeight)
    
    -- Berechnet den maximalen Scrollweg millimetergenau im Hintergrund
    maxScroll = calculatedChildHeight - 212
    currentScrollOffset = 0 -- Setzt das Fenster beim Öffnen immer brav nach ganz oben zurück
    UpdateScrollPosition()
end)

-- ============================================================================
-- 6. DIRECT MOUSEWHEEL ENGINE
-- ============================================================================
local function OnMouseWheelScroll(self, delta)
    if maxScroll <= 0 then return end
    if delta > 0 then
        currentScrollOffset = math.max(0, currentScrollOffset - 20)
    else
        currentScrollOffset = math.min(maxScroll, currentScrollOffset + 20)
    end
    UpdateScrollPosition()
end

card:EnableMouseWheel(true)
card:SetScript("OnMouseWheel", OnMouseWheelScroll)

scrollFrame:EnableMouseWheel(true)
scrollFrame:SetScript("OnMouseWheel", OnMouseWheelScroll)

scrollChild:EnableMouseWheel(true)
scrollChild:SetScript("OnMouseWheel", OnMouseWheelScroll)
