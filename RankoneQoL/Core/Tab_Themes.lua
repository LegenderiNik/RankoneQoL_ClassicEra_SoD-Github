-- ============================================================================
-- RankoneQoL - Interface Tab: Themes - TEIL 1 von 2 (Bottom-Docking-Engine)
-- ============================================================================

local L = RankoneQoL_Locals
local MainFrame = RankoneQoL_GetMainFrame()

-- 1. TAB & PANEL IM GEHÄUSE REGISTRIEREN
-- FIX: Nutzt jetzt "true" (unten fixiert) und sitzt mathematisch exakt auf Position 80 über Options!
local themesTab = RankoneQoL_CreateVectorTab("THEMES", L["TAB_THEMES"], 80, true)
if themesTab then 
    themesTab:SetSize(130, 24) 
    if themesTab.glowBar then themesTab.glowBar:SetSize(2, 22) end 
end
local themesPanel = RankoneQoL_CreateContentPanel("THEMES")

-- ============================================================================
-- 2. HILFSFUNKTION FÜR STRUKTURIERTE KACHELN
-- ============================================================================
local function CreateSubCard(name, titleText, x, y, width, height)
    local baseFrame = RankoneQoL_GetMainFrame()
    local card = CreateFrame("Frame", "RankoneQoLThemesCard_"..name, themesPanel, "BackdropTemplate")
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
-- 3. HAUPTKACHEL: VISUAL SETTINGS
-- ============================================================================
local visualCard = CreateSubCard("VisualSettings", L["CARD_THEME_SETTINGS"], 165, -45, 420, 185)

-- A) MENÜ-SCHRIFTGRÖSSEN-SLIDER
local sizeSlider = CreateFrame("Slider", "RankoneQoLThemesSizeSlider", visualCard, "OptionsSliderTemplate")
sizeSlider:SetPoint("TOPLEFT", visualCard, "TOPLEFT", 16, -54)
sizeSlider:SetSize(140, 16)
sizeSlider:SetMinMaxValues(10, 20)
sizeSlider:SetValueStep(1)
sizeSlider:SetObeyStepOnDrag(true)
sizeSlider:SetFrameLevel(visualCard:GetFrameLevel() + 1)

local sliderTrack = sizeSlider:CreateTexture(nil, "BACKGROUND")
sliderTrack:SetSize(140, 2)
sliderTrack:SetPoint("CENTER", sizeSlider, "CENTER", 0, 0)
sliderTrack:SetColorTexture(0.15, 0.15, 0.15, 1)

local sliderLabel = sizeSlider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
sliderLabel:SetPoint("TOPLEFT", visualCard, "TOPLEFT", 16, -34)
sliderLabel:SetText(L["LABEL_FONT_SIZE"])
RankoneQoL_RegisterFontString(sliderLabel)

local sliderVal = sizeSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
sliderVal:SetPoint("LEFT", sizeSlider, "RIGHT", 12, 0)
RankoneQoL_RegisterFontString(sliderVal)

local thumb = sizeSlider:GetThumbTexture()
if thumb then
    thumb:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    thumb:SetSize(4, 10)
    thumb:SetVertexColor(0.0, 0.75, 1.0, 1.0)
end

sizeSlider:SetScript("OnShow", function(self)
    local currentSize = RankoneQoL_Profile.menuFontSize or 12
    self:SetValue(currentSize)
    sliderVal:SetText(currentSize .. " px")
end)

sizeSlider:SetScript("OnValueChanged", function(self, value)
    local rounded = math.floor(value + 0.5)
    RankoneQoL_Profile.menuFontSize = rounded
    sliderVal:SetText(rounded .. " px")
    RankoneQoL_UpdateMenuFontsLive()
end)

if RankoneQoLThemesSizeSliderLow then RankoneQoLThemesSizeSliderLow:Hide() end
if RankoneQoLThemesSizeSliderHigh then RankoneQoLThemesSizeSliderHigh:Hide() end

-- B) TOOLTIP-SKALIERUNGS-SLIDER
local scaleSlider = CreateFrame("Slider", "RankoneQoLThemesTooltipScaleSlider", visualCard, "OptionsSliderTemplate")
scaleSlider:SetPoint("TOPLEFT", visualCard, "TOPLEFT", 16, -114)
scaleSlider:SetSize(140, 16)
scaleSlider:SetMinMaxValues(0.8, 1.2)
scaleSlider:SetValueStep(0.05)
scaleSlider:SetObeyStepOnDrag(true)
scaleSlider:SetFrameLevel(visualCard:GetFrameLevel() + 1)

local scaleTrack = scaleSlider:CreateTexture(nil, "BACKGROUND")
scaleTrack:SetSize(140, 2)
scaleTrack:SetPoint("CENTER", scaleSlider, "CENTER", 0, 0)
scaleTrack:SetColorTexture(0.15, 0.15, 0.15, 1)

local scaleLabel = scaleSlider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
scaleLabel:SetPoint("TOPLEFT", visualCard, "TOPLEFT", 16, -94)
scaleLabel:SetText(L["LABEL_TOOLTIP_SCALE"])
RankoneQoL_RegisterFontString(scaleLabel)

local scaleVal = scaleSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
scaleVal:SetPoint("LEFT", scaleSlider, "RIGHT", 12, 0)
RankoneQoL_RegisterFontString(scaleVal)

local scaleThumb = scaleSlider:GetThumbTexture()
if scaleThumb then
    scaleThumb:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    scaleThumb:SetSize(4, 10)
    scaleThumb:SetVertexColor(0.0, 0.75, 1.0, 1.0)
end

scaleSlider:SetScript("OnShow", function(self)
    local currentScale = RankoneQoL_Profile.tooltipScale or 1.0
    self:SetValue(currentScale)
    scaleVal:SetText(math.floor(currentScale * 100 + 0.5) .. " %")
end)

scaleSlider:SetScript("OnValueChanged", function(self, value)
    local stepValue = math.floor(value * 20 + 0.5) / 20
    RankoneQoL_Profile.tooltipScale = stepValue
    scaleVal:SetText(math.floor(stepValue * 100 + 0.5) .. " %")
    if GameTooltip then GameTooltip:SetScale(stepValue) end
    if ItemRefTooltip then ItemRefTooltip:SetScale(stepValue) end
end)

if RankoneQoLThemesTooltipScaleSliderLow then RankoneQoLThemesTooltipScaleSliderLow:Hide() end
if RankoneQoLThemesTooltipScaleSliderHigh then RankoneQoLThemesTooltipScaleSliderHigh:Hide() end
-- ============================================================================
-- RankoneQoL - Interface Tab: Themes - TEIL 2 von 2 (Dropdown Controls)
-- ============================================================================

-- C) SCHRIFTARTEN-DROPDOWN
local fontLabel = visualCard:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
fontLabel:SetPoint("TOPLEFT", visualCard, "TOPLEFT", 215, -34)
fontLabel:SetText(L["LABEL_SELECT_FONT"])
RankoneQoL_RegisterFontString(fontLabel)

local dropButton = CreateFrame("Button", "RankoneQoLDropButton", visualCard, "BackdropTemplate")
dropButton:SetSize(190, 24)
dropButton:SetPoint("TOPLEFT", visualCard, "TOPLEFT", 215, -54)
dropButton:SetFrameLevel(visualCard:GetFrameLevel() + 1)
dropButton:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
dropButton:SetBackdropColor(0.04, 0.04, 0.04, 0.9)
dropButton:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)

local dropText = dropButton:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
dropText:SetPoint("LEFT", dropButton, "LEFT", 8, 0)
RankoneQoL_RegisterFontString(dropText)

local dropArrow = dropButton:CreateTexture(nil, "OVERLAY")
dropArrow:SetSize(12, 12)
dropArrow:SetPoint("RIGHT", dropButton, "RIGHT", -8, -4)
dropArrow:SetTexture("Interface\\Calendar\\MoreArrow")
dropArrow:SetVertexColor(0.0, 0.75, 1.0, 1.0)

local dropList = CreateFrame("Frame", "RankoneQoL_DropList", visualCard, "BackdropTemplate")
dropList:SetSize(190, 92) 
dropList:SetPoint("TOPLEFT", dropButton, "BOTTOMLEFT", 0, -2)
dropList:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
dropList:SetBackdropColor(0.02, 0.02, 0.02, 0.96)
dropList:SetBackdropBorderColor(0.12, 0.12, 0.12, 0.8)
dropList:Hide()
dropList:SetFrameLevel(MainFrame:GetFrameLevel() + 5)

local scrollBar = CreateFrame("Frame", nil, dropList, "BackdropTemplate")
scrollBar:SetSize(4, 84)
scrollBar:SetPoint("RIGHT", dropList, "RIGHT", -6, 0)
scrollBar:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground"})
scrollBar:SetBackdropColor(0.06, 0.06, 0.06, 1)

local scrollThumb = scrollBar:CreateTexture(nil, "OVERLAY")
scrollThumb:SetSize(4, 30)
scrollThumb:SetColorTexture(0.0, 0.75, 1.0, 0.6)

local scrollOffset = 0
local fontButtons = {}

local function UpdateDropdownItems()
    local totalFonts = #RankoneQoL_Fonts
    local maxOffset = totalFonts - 4
    for i = 1, 4 do
        local fontIndex = i + scrollOffset
        local btn = fontButtons[i]
        if fontIndex <= totalFonts then
            local data = RankoneQoL_Fonts[fontIndex]
            btn.text:SetText(data.name)
            btn.fontName = data.name
            btn:Show()
            if data.name == RankoneQoL_Profile.menuFont then btn.text:SetTextColor(0.0, 0.75, 1.0, 1) else btn.text:SetTextColor(0.8, 0.8, 0.8, 1) end
        else btn:Hide() end
    end
    if maxOffset > 0 then scrollBar:Show() local step = 54 / maxOffset scrollThumb:SetPoint("TOP", scrollBar, "TOP", 0, -(scrollOffset * step)) else scrollBar:Hide() end
end

for i = 1, 4 do
    local btn = CreateFrame("Button", nil, dropList, "BackdropTemplate")
    btn:SetSize(174, 22)
    btn:SetPoint("TOPLEFT", dropList, "TOPLEFT", 1, -((i-1)*22) - 4)
    btn:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground"})
    btn:SetBackdropColor(0, 0, 0, 0)
    btn.text = btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    btn.text:SetPoint("LEFT", btn, "LEFT", 10, 0)
    RankoneQoL_RegisterFontString(btn.text)
    btn:SetScript("OnEnter", function(self) self:SetBackdropColor(0.0, 0.4, 0.6, 0.2) end)
    btn:SetScript("OnLeave", function(self) self:SetBackdropColor(0, 0, 0, 0) end)
    btn:SetScript("OnClick", function(self)
        RankoneQoL_Profile.menuFont = self.fontName
        dropText:SetText(self.fontName)
        RankoneQoL_UpdateMenuFontsLive()
        dropList:Hide()
    end)
    fontButtons[i] = btn
end

dropList:SetScript("OnMouseWheel", function(self, delta)
    local maxOffset = #RankoneQoL_Fonts - 4
    if delta > 0 then scrollOffset = math.max(0, scrollOffset - 1) else scrollOffset = math.min(maxOffset, scrollOffset + 1) end
    UpdateDropdownItems()
end)

dropButton:SetScript("OnClick", function()
    if RankoneQoL_ThemeList and RankoneQoL_ThemeList:IsShown() then RankoneQoL_ThemeList:Hide() end
    if dropList:IsShown() then dropList:Hide() else scrollOffset = 0 dropList:Show() UpdateDropdownItems() end
end)
dropButton:SetScript("OnShow", function() dropText:SetText(RankoneQoL_Profile.menuFont) end)

-- D) DESIGN-DROPDOWN
local themeLabel = visualCard:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
themeLabel:SetPoint("TOPLEFT", visualCard, "TOPLEFT", 215, -94)
themeLabel:SetText(L["LABEL_SELECT_THEME"])
RankoneQoL_RegisterFontString(themeLabel)

local themeDropBtn = CreateFrame("Button", "RankoneQoLThemeDropButton", visualCard, "BackdropTemplate")
themeDropBtn:SetSize(190, 24)
themeDropBtn:SetPoint("TOPLEFT", visualCard, "TOPLEFT", 215, -114)
themeDropBtn:SetFrameLevel(visualCard:GetFrameLevel() + 1)
themeDropBtn:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
themeDropBtn:SetBackdropColor(0.04, 0.04, 0.04, 0.9)
themeDropBtn:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)

local themeDropTxt = themeDropBtn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
themeDropTxt:SetPoint("LEFT", themeDropBtn, "LEFT", 8, 0)
RankoneQoL_RegisterFontString(themeDropTxt)

themeDropBtn:SetScript("OnShow", function()
    local currentThemeKey = RankoneQoL_Profile.menuTheme or "neon_cyan"
    for _, t in ipairs(RankoneQoL_MenuThemes) do
        if t.key == currentThemeKey then
            themeDropTxt:SetText(t.name)
            break
        end
    end
end)

local themeDropArrow = themeDropBtn:CreateTexture(nil, "OVERLAY")
themeDropArrow:SetSize(12, 12)
themeDropArrow:SetPoint("RIGHT", themeDropBtn, "RIGHT", -8, -4)
themeDropArrow:SetTexture("Interface\\Calendar\\MoreArrow")
themeDropArrow:SetVertexColor(0.0, 0.75, 1.0, 1.0)

local themeDropList = CreateFrame("Frame", "RankoneQoL_ThemeList", visualCard, "BackdropTemplate")
themeDropList:SetSize(190, 92) 
themeDropList:SetPoint("TOPLEFT", themeDropBtn, "BOTTOMLEFT", 0, -2)
themeDropList:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
themeDropList:SetBackdropColor(0.02, 0.02, 0.02, 0.96)
themeDropList:SetBackdropBorderColor(0.12, 0.12, 0.12, 0.8)
themeDropList:Hide()
themeDropList:SetFrameLevel(MainFrame:GetFrameLevel() + 5)

local themeButtons = {}

for i = 1, 4 do
    local btn = CreateFrame("Button", nil, themeDropList, "BackdropTemplate")
    btn:SetSize(188, 22)
    btn:SetPoint("TOPLEFT", themeDropList, "TOPLEFT", 1, -((i-1)*22) - 4)
    btn:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground"})
    btn:SetBackdropColor(0, 0, 0, 0)
    btn.text = btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    btn.text:SetPoint("LEFT", btn, "LEFT", 10, 0)
    RankoneQoL_RegisterFontString(btn.text)
    
    btn:SetScript("OnEnter", function(self) self:SetBackdropColor(0.0, 0.4, 0.6, 0.2) end)
    btn:SetScript("OnLeave", function(self) self:SetBackdropColor(0, 0, 0, 0) end)
    
    btn:SetScript("OnClick", function(self)
        RankoneQoL_Profile.menuTheme = self.themeKey
        themeDropTxt:SetText(self.themeName)
        themeDropList:Hide()
        if RankoneQoL_UpdateMenuThemeLive then
            RankoneQoL_UpdateMenuThemeLive()
        end
    end)
    themeButtons[i] = btn
end

local function UpdateThemeDropdownItems()
    for i = 1, 4 do
        local data = RankoneQoL_MenuThemes[i]
        local btn = themeButtons[i]
        if data then
            btn.text:SetText(data.name)
            btn.themeKey = data.key
            btn.themeName = data.name
            btn:Show()
            if data.key == RankoneQoL_Profile.menuTheme then 
                btn.text:SetTextColor(0.0, 0.75, 1.0, 1) 
            else 
                btn.text:SetTextColor(0.8, 0.8, 0.8, 1) 
            end
        else
            btn:Hide()
        end
    end
end

themeDropBtn:SetScript("OnClick", function()
    if RankoneQoL_DropList and RankoneQoL_DropList:IsShown() then RankoneQoL_DropList:Hide() end
    if themeDropList:IsShown() then 
        themeDropList:Hide() 
    else 
        themeDropList:Show() 
        UpdateThemeDropdownItems() 
    end
end)
