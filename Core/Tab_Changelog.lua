-- ============================================================================
-- RankoneQoL - Interface Tab: Changelog (Multi-Page Scroll Engine) - TEIL 1 von 2
-- ============================================================================

local L = RankoneQoL_Locals
local MainFrame = RankoneQoL_GetMainFrame()

-- 1. TAB & PANEL IM GEHÄUSE REGISTRIEREN
-- FIX: Rutscht jetzt auf die allerunterste Position am Gehäuseboden (16px Abstand)
local changelogTab = RankoneQoL_CreateVectorTab("CHANGELOG", L["TAB_CHANGELOG"], 16, true)
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
scrollFrame:SetSize(360, 185) 
scrollFrame:SetPoint("TOPLEFT", card, "TOPLEFT", 14, -14)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(360, 185) 
scrollFrame:SetScrollChild(scrollChild)

-- Die Überschrift der aktuellen Version
local titleContainer = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
titleContainer:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0)
titleContainer:SetWidth(360)
titleContainer:SetJustifyH("LEFT")
RankoneQoL_RegisterFontString(titleContainer)

-- Die Trennlinie unter dem Titel
local titleLine = scrollChild:CreateTexture(nil, "ARTWORK")
titleLine:SetHeight(1)
titleLine:SetPoint("TOPLEFT", titleContainer, "BOTTOMLEFT", 0, -6)
titleLine:SetPoint("TOPRIGHT", titleContainer, "BOTTOMRIGHT", 0, -6)
titleLine:SetColorTexture(0.15, 0.15, 0.15, 0.8)

-- Der eigentliche Inhaltstext
local textContainer = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
textContainer:SetPoint("TOPLEFT", titleLine, "BOTTOMLEFT", 0, -8)
textContainer:SetWidth(360)
textContainer:SetJustifyH("LEFT")
textContainer:SetJustifyV("TOP")
textContainer:SetSpacing(4) 
RankoneQoL_RegisterFontString(textContainer)

-- ============================================================================
-- 4. SCI-FI SCROLLBAR DESIGN
-- ============================================================================
local customScrollBar = CreateFrame("Frame", nil, card, "BackdropTemplate")
customScrollBar:SetSize(6, 185)
customScrollBar:SetPoint("RIGHT", card, "RIGHT", -10, 12)
customScrollBar:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
})
customScrollBar:SetBackdropColor(0.08, 0.08, 0.08, 1)
customScrollBar:SetBackdropBorderColor(0.16, 0.16, 0.16, 0.6)

local customThumb = customScrollBar:CreateTexture(nil, "OVERLAY")
customThumb:SetSize(6, 30) 
customThumb:SetColorTexture(0.0, 0.75, 1.0, 0.75)
customThumb:SetPoint("TOP", customScrollBar, "TOP", 0, 0)

-- Triangulations-Variablen für die Blätter-Engine
local currentPageIndex = 1
local maxScroll = 0
local currentScrollOffset = 0

local function UpdateScrollPosition()
    if maxScroll <= 0 then 
        scrollFrame:SetVerticalScroll(0)
        customThumb:SetPoint("TOP", customScrollBar, "TOP", 0, 0)
        return 
    end
    scrollFrame:SetVerticalScroll(currentScrollOffset)
    local progress = currentScrollOffset / maxScroll
    local maxThumbPath = 185 - 30
    customThumb:SetPoint("TOP", customScrollBar, "TOP", 0, -(progress * maxThumbPath))
end
-- ============================================================================
-- RankoneQoL - Interface Tab: Changelog (Multi-Page Scroll Engine) - TEIL 2 von 2
-- ============================================================================

-- Textanzeige für die aktuelle Seitenzahl unten zentriert
local pageText = card:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
pageText:SetPoint("BOTTOM", card, "BOTTOM", 0, 10)
pageText:SetTextColor(0.55, 0.55, 0.55, 1)
RankoneQoL_RegisterFontString(pageText)

-- ============================================================================
-- 5. THE DYNAMIC AUTO-HEIGHT & PAGE REFRESH ENGINE
-- ============================================================================
local function RefreshChangelogPage()
    local pageData = RankoneQoL_ChangelogPages[currentPageIndex]
    if not pageData then return end

    titleContainer:SetText(pageData.title or "")
    textContainer:SetText(pageData.text or "Kein Inhalt auf dieser Seite vorhanden.")
    pageText:SetText(string.format("Page %d / %d", currentPageIndex, #RankoneQoL_ChangelogPages))

    C_Timer.After(0.01, function()
        local titleHeight = titleContainer:GetStringHeight()
        local textHeight = textContainer:GetStringHeight()
        local totalNeededHeight = titleHeight + 6 + 8 + textHeight + 20

        local calculatedChildHeight = math.max(185, totalNeededHeight)
        scrollChild:SetSize(360, calculatedChildHeight)

        maxScroll = calculatedChildHeight - 185
        currentScrollOffset = 0
        UpdateScrollPosition()
    end)
end

-- ============================================================================
-- 6. SCI-FI NAVIGATIONS-BUTTONS
-- ============================================================================
local function CreatePageButton(name, text, point, xOffset)
    local btn = CreateFrame("Button", nil, card, "BackdropTemplate")
    btn:SetSize(22, 16)
    btn:SetPoint(point, card, point, xOffset, 8)
    btn:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    btn:SetBackdropColor(0.02, 0.02, 0.02, 0.6)
    
    local btnText = btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    btnText:SetPoint("CENTER", 0, 0)
    btnText:SetText(text)
    btn.text = btnText
    RankoneQoL_RegisterFontString(btnText)
    
    btn:SetScript("OnEnter", function(self)
        local currentThemeKey = RankoneQoL_Profile and RankoneQoL_Profile.menuTheme or "neon_cyan"
        local c = nil
        if RankoneQoL_MenuThemes then
            for _, theme in ipairs(RankoneQoL_MenuThemes) do if theme.key == currentThemeKey then c = theme break end end
        end
        local r, g, b = (c and c.accentR or 0.0), (c and c.accentG or 0.75), (c and c.accentB or 1.0)
        
        self:SetBackdropBorderColor(r, g, b, 0.8)
        self.text:SetTextColor(r, g, b, 1)
    end)
    
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.16, 0.16, 0.16, 0.6)
        self.text:SetTextColor(1, 1, 1, 1)
    end)
    
    return btn
end

local prevBtn = CreatePageButton("Prev", "<", "BOTTOMLEFT", 14)
prevBtn:SetScript("OnClick", function()
    if currentPageIndex > 1 then
        currentPageIndex = currentPageIndex - 1
        PlaySound(SOUNDKIT.IG_CHAT_SCROLL_UP)
        RefreshChangelogPage()
    end
end)

local nextBtn = CreatePageButton("Next", ">", "BOTTOMRIGHT", -26)
nextBtn:SetScript("OnClick", function()
    if currentPageIndex < #RankoneQoL_ChangelogPages then
        currentPageIndex = currentPageIndex + 1
        PlaySound(SOUNDKIT.IG_CHAT_SCROLL_DOWN)
        RefreshChangelogPage()
    end
end)

card:SetScript("OnShow", function()
    currentPageIndex = 1
    RefreshChangelogPage()
    
    if #RankoneQoL_ChangelogPages <= 1 then
        prevBtn:Hide()
        nextBtn:Hide()
    else
        prevBtn:Show()
        nextBtn:Show()
    end
end)

-- ============================================================================
-- 7. DIRECT MOUSEWHEEL ENGINE
-- ============================================================================
local function OnMouseWheelScroll(self, delta)
    if maxScroll <= 0 then return end
    if delta > 0 then
        currentScrollOffset = math.max(0, currentScrollOffset - 25)
    else
        currentScrollOffset = math.min(maxScroll, currentScrollOffset + 25)
    end
    UpdateScrollPosition()
end

card:EnableMouseWheel(true)
card:SetScript("OnMouseWheel", OnMouseWheelScroll)

scrollFrame:EnableMouseWheel(true)
scrollFrame:SetScript("OnMouseWheel", OnMouseWheelScroll)

scrollChild:EnableMouseWheel(true)
scrollChild:SetScript("OnMouseWheel", OnMouseWheelScroll)
