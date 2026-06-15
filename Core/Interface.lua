-- ============================================================================
-- RankoneQoL - Hauptinterface & Theme Engine Kernel - TEIL 1 von 3 (ESC Close Fix)
-- ============================================================================

local L = RankoneQoL_Locals

-- 1. GRAPHICAL FRAME-ZENTRALE
local MainFrame = CreateFrame("Frame", "RankoneQoLMainFrame", UIParent, "BackdropTemplate")
MainFrame:SetSize(600, 310)
MainFrame:SetPoint("CENTER", UIParent, "CENTER")
MainFrame:SetFrameStrata("MEDIUM")
MainFrame:EnableMouse(true)
MainFrame:SetMovable(true)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)
MainFrame:Hide()

function RankoneQoL_GetMainFrame() return MainFrame end

-- FIX: Registriert das Menü im globalen Blizzard-Register für die ESC-Taste!
tinsert(UISpecialFrames, "RankoneQoLMainFrame")

-- 2. DYNAMISCHE STRUKTUR-TABELLEN FÜR DIE THEMING-ENGINE
local Panels = {}
local Tabs = {}
local FontStrings = {}

function RankoneQoL_RegisterFontString(fs)
    if fs then table.insert(FontStrings, fs) end
end

-- ============================================================================
-- 3. THEME ENGINE LOGIK: LÄDT CODELISTEN AUS UIMENUDESIGNS.LUA LIVE INVOKE
-- ============================================================================
function RankoneQoL_UpdateMenuThemeLive()
    local currentThemeKey = RankoneQoL_Profile and RankoneQoL_Profile.menuTheme or "neon_cyan"
    local c = nil
    
    -- Holt das passende Farb-Paket aus dem Datentresor
    for _, theme in ipairs(RankoneQoL_MenuThemes) do
        if theme.key == currentThemeKey then c = theme break end
    end
    if not c then return end
    
    -- A) Hauptgehäuse umfärben
    MainFrame:SetBackdropColor(c.bgR, c.bgG, c.bgB, c.bgAlpha)
    MainFrame:SetBackdropBorderColor(c.borderR, c.borderG, c.borderB, c.borderAlpha)
    
    -- B) Alle Sub-Kacheln (SubCards) in allen Tabs live umfärben
    local globalCard = _G["RankoneQoLCard_Merchant"] or _G["RankoneQoLCard_World"] or _G["RankoneQoLCard_SpeedrunOps"] or _G["RankoneQoLCard_Changelog"] or _G["RankoneQoLCard_ProfileManagement"] or _G["RankoneQoLThemesCard_VisualSettings"] or _G["RankoneQoLThemesCard_ProfileManagement"]
    if globalCard then
        globalCard:SetBackdropColor(c.bgR + 0.03, c.bgG + 0.03, c.bgB + 0.03, c.bgAlpha)
        globalCard:SetBackdropBorderColor(c.borderR, c.borderG, c.borderB, c.borderAlpha)
    end
    
    -- C) Alle Tabs und deren kleine Vektor-Leuchtbalken (glowBar) anpassen
    for id, tabButton in pairs(Tabs) do
        if tabButton.glowBar then
            tabButton.glowBar:SetColorTexture(c.accentR, c.accentG, c.accentB, c.accentAlpha * 0.8)
        end
        if tabButton.isActive then
            tabButton.text:SetTextColor(c.accentR, c.accentG, c.accentB, 1)
        end
    end
    
    -- D) Schieberegler-Daumen (Thumbs) anpassen
    local slider1 = _G["RankoneQoLThemesSizeSlider"]
    if slider1 then local thumb = slider1:GetThumbTexture() if thumb then thumb:SetVertexColor(c.accentR, c.accentG, c.accentB, 1) end end
    local slider2 = _G["RankoneQoLThemesTooltipScaleSlider"]
    if slider2 then local thumb = slider2:GetThumbTexture() if thumb then thumb:SetVertexColor(c.accentR, c.accentG, c.accentB, 1) end end
    
    -- E) Dropdown-Pfeile anpassen
    local targetButtons = { _G["RankoneQoLDropButton"], _G["RankoneQoLThemeDropButton"], _G["RankoneQoLProfileDropButton"] }
    for _, btn in ipairs(targetButtons) do
        if btn then
            btn:SetBackdropColor(0.04, 0.04, 0.04, 0.9)
            btn:SetBackdropBorderColor(c.borderR, c.borderG, c.borderB, c.borderAlpha)
            
            for _, reg in ipairs({btn:GetRegions()}) do
                if reg:GetObjectType() == "Texture" then
                    local texturePath = reg:GetTexture()
                    if texturePath and (string.find(string.lower(texturePath), "arrow") or string.find(string.lower(texturePath), "morearrow")) then
                        reg:SetVertexColor(c.accentR, c.accentG, c.accentB, c.accentAlpha)
                    end
                end
            end
        end
    end
end

-- ============================================================================
-- 4. LOGO, HEADER-SCHRIFTZUG UND HINTERGRUND-INITIALISIERUNG
-- ============================================================================
MainFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile = true, tileSize = 16, edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
})

local addonLogo = MainFrame:CreateTexture(nil, "ARTWORK")
addonLogo:SetSize(30, 30)
addonLogo:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 14, -10)
addonLogo:SetTexture("Interface\\AddOns\\RankoneQoL\\logo")

local titleText = MainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
titleText:SetPoint("LEFT", addonLogo, "RIGHT", 10, 0)
titleText:SetText(L["TITLE_SETTINGS"])
table.insert(FontStrings, titleText)
-- ============================================================================
-- RankoneQoL - Hauptinterface & Theme Engine Kernel - TEIL 2 von 3
-- ============================================================================

-- ============================================================================
-- 5. FUNCTION VEKTOR-TAB ENGINE (Baut die Menüknöpfe links auf)
-- ============================================================================
function RankoneQoL_CreateVectorTab(id, label, yOffset, isFixedBottom)
    local tab = CreateFrame("Button", "RankoneQoLTab_"..id, MainFrame, "BackdropTemplate")
    tab:SetSize(130, 24)
    
    -- Unterscheidet zwischen festen Buttons unten und stapelbaren Inhaltstabs oben
    if isFixedBottom then
        tab:SetPoint("BOTTOMLEFT", MainFrame, "BOTTOMLEFT", 12, yOffset)
    else
        tab:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 12, yOffset)
    end
    
    tab:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    tab:SetBackdropColor(0.02, 0.02, 0.02, 0.4)
    tab:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.5)
    
    -- Der feine Vektor-Leuchtstreifen an der linken Kante des Buttons
    local glowBar = tab:CreateTexture(nil, "OVERLAY")
    glowBar:SetSize(2, 22)
    glowBar:SetPoint("LEFT", tab, "LEFT", 2, 0)
    tab.glowBar = glowBar
    
    local txt = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    txt:SetPoint("LEFT", tab, "LEFT", 14, 0)
    txt:SetText(label)
    tab.text = txt
    table.insert(FontStrings, txt)
    
    tab.id = id
    tab.isActive = false
    Tabs[id] = tab
    
    -- Click-Logik: Blendet die Panels um und färbt die Tabs passend zum aktiven Theme
    tab:SetScript("OnClick", function(self)
        -- Sucht nach den aktuellen Akzentfarben im Datentresor
        local currentThemeKey = RankoneQoL_Profile and RankoneQoL_Profile.menuTheme or "neon_cyan"
        local c = nil
        for _, theme in ipairs(RankoneQoL_MenuThemes) do
            if theme.key == currentThemeKey then c = theme break end
        end
        if not c then return end

        for panelID, panelFrame in pairs(Panels) do
            if panelID == self.id then panelFrame:Show() else panelFrame:Hide() end
        end
        
        for tabID, tabBtn in pairs(Tabs) do
            if tabID == self.id then
                tabBtn.isActive = true
                tabBtn:SetBackdropColor(0.04, 0.04, 0.04, 0.8)
                tabBtn:SetBackdropBorderColor(0.18, 0.18, 0.18, 0.9)
                tabBtn.text:SetTextColor(c.accentR, c.accentG, c.accentB, 1) -- Setzt leuchtende Akzentfarbe
                if tabBtn.glowBar then tabBtn.glowBar:Show() end
            else
                tabBtn.isActive = false
                tabBtn:SetBackdropColor(0.02, 0.02, 0.02, 0.4)
                tabBtn:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.5)
                tabBtn.text:SetTextColor(0.55, 0.55, 0.55, 1) -- Inaktives Grau
                if tabBtn.glowBar then tabBtn.glowBar:Hide() end
            end
        end
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
    end)
    
    tab:SetScript("OnEnter", function(self)
        if not self.isActive then
            self.text:SetTextColor(0.85, 0.85, 0.85, 1)
            self:SetBackdropBorderColor(0.14, 0.14, 0.14, 0.7)
        end
    end)
    
    tab:SetScript("OnLeave", function(self)
        if not self.isActive then
            self.text:SetTextColor(0.55, 0.55, 0.55, 1)
            self:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.5)
        end
    end)
    
    return tab
end

-- ============================================================================
-- 6. FUNCTION CONTENT-PANEL ENGINE (Baut das unsichtbare Panel-Gehäuse)
-- ============================================================================
function RankoneQoL_CreateContentPanel(id)
    local panel = CreateFrame("Frame", "RankoneQoLPanel_"..id, MainFrame)
    panel:SetSize(420, 240)
    panel:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 165, -45)
    panel:Hide()
    Panels[id] = panel
    return panel
end
-- ============================================================================
-- RankoneQoL - Hauptinterface & Theme Engine Kernel - TEIL 3 von 3
-- ============================================================================

-- ============================================================================
-- 7. SCHLIESSEN-BUTTON (Das edle Sci-Fi Kreuz oben rechts)
-- ============================================================================
local closeBtn = CreateFrame("Button", "RankoneQoLCloseButton", MainFrame, "BackdropTemplate")
closeBtn:SetSize(16, 16)
closeBtn:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -14, -17)
closeBtn:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground"})
closeBtn:SetBackdropColor(0, 0, 0, 0)

local closeText = closeBtn:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
closeText:SetPoint("CENTER", 0, 0)
closeText:SetText("|cFFFF2222×|r")
closeBtn.text = closeText
RankoneQoL_RegisterFontString(closeText)

closeBtn:SetScript("OnEnter", function(self) self.text:SetText("|cFFFF5555×|r") end)
closeBtn:SetScript("OnLeave", function(self) self.text:SetText("|cFFFF2222×|r") end)
closeBtn:SetScript("OnClick", function() MainFrame:Hide() PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE) end)

-- ============================================================================
-- 8. GLOBAL ENGINE CONTROLS (Umschalten, Schrift-Live-Skalierung & First-Load)
-- ============================================================================
function RankoneQoL_ToggleUI()
    if MainFrame:IsShown() then
        MainFrame:Hide()
        PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
    else
        MainFrame:Show()
        -- Zwingt das aktive Panel beim allerersten Öffnen auf den Standard ("AUTOMATION")
        if Tabs["AUTOMATION"] and not Tabs["AUTOMATION"].isActive then
            Tabs["AUTOMATION"]:Click()
        end
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    end
end

-- Aktualisiert live alle im System registrierten Schriften im Menü
function RankoneQoL_UpdateMenuFontsLive()
    if not RankoneQoL_Profile then return end
    local fontName = RankoneQoL_Profile.menuFont or "WoW Friz Quadrata"
    local fontSize = RankoneQoL_Profile.menuFontSize or 12
    local fontPath = nil
    
    for _, f in ipairs(RankoneQoL_Fonts) do
        if f.name == fontName then fontPath = f.path break end
    end
    if not fontPath then return end
    
    for _, fs in ipairs(FontStrings) do
        if fs and fs.SetFont then
            fs:SetFont(fontPath, fontSize, "OUTLINE")
        end
    end
end

-- INITIALISIERUNG BEIM ÖFFNEN DES MENÜS
MainFrame:SetScript("OnShow", function(self)
    -- 1. Wendet sofort das gespeicherte Theme aus dem Datentresor an
    if RankoneQoL_UpdateMenuThemeLive then
        RankoneQoL_UpdateMenuThemeLive()
    end
    -- 2. Wendet sofort die gespeicherte Schriftgröße an
    RankoneQoL_UpdateMenuFontsLive()
end)
