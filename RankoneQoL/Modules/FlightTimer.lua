-- ============================================================================
-- RankoneQoL - Modul: Sci-Fi Flight Time Left Tracker - TEIL 1 von 2 (UI & Logic)
-- ============================================================================

local FlightTimerFrame = CreateFrame("Frame", "RankoneQoLFlightTimer", UIParent, "BackdropTemplate")
FlightTimerFrame:SetSize(180, 14) -- Edle, schmale 180x14px Geometrie
FlightTimerFrame:SetPoint("TOP", UIParent, "TOP", 0, -60) -- Perfekt zentriert unter der Buff-Leiste
FlightTimerFrame:Hide()

-- 1. DIE HINTERGRUND-KACHEL (0.82 Transparenz passend zum Hauptmenü)
FlightTimerFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    tile = true, tileSize = 16, edgeSize = 1,
    insets = { left = 1, right = 1, top = 1, bottom = 1 }
})

-- 2. DER VEKTOR-FÜLLBALKEN
local statusProgress = FlightTimerFrame:CreateTexture(nil, "ARTWORK")
statusProgress:SetHeight(12)
statusProgress:SetPoint("LEFT", FlightTimerFrame, "LEFT", 1, 0)
FlightTimerFrame.bar = statusProgress

-- 3. DIE HIGH-TECH HUD TEXTANZEIGE
local timerText = FlightTimerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
timerText:SetPoint("CENTER", FlightTimerFrame, "CENTER", 0, 0)
FlightTimerFrame.text = timerText

if RankoneQoL_RegisterFontString then
    RankoneQoL_RegisterFontString(timerText)
end

-- ============================================================================
-- 4. THEME SYNC ENGINE (Passt die Füllleiste live an dein Menü-Design an)
-- ============================================================================
local function SyncTimerColorWithActiveTheme()
    local currentThemeKey = RankoneQoL_Profile and RankoneQoL_Profile.menuTheme or "neon_cyan"
    local c = nil
    
    if RankoneQoL_MenuThemes then
        for _, theme in ipairs(RankoneQoL_MenuThemes) do
            if theme.key == currentThemeKey then c = theme break end
        end
    end
    
    -- Fallback auf Cyan, falls der Tresor blockiert ist
    if not c then
        c = { bgR = 0.01, bgG = 0.01, bgB = 0.01, bgAlpha = 0.82, borderR = 0.15, borderG = 0.15, borderB = 0.15, borderAlpha = 0.9, accentR = 0.0, accentG = 0.75, accentB = 1.0, accentAlpha = 1.0 }
    end
    
    FlightTimerFrame:SetBackdropColor(c.bgR, c.bgG, c.bgB, c.bgAlpha)
    FlightTimerFrame:SetBackdropBorderColor(c.borderR, c.borderG, c.borderB, c.borderAlpha)
    FlightTimerFrame.bar:SetColorTexture(c.accentR, c.accentG, c.accentB, 0.75) -- Schicker 75% Akzent-Glow
end

-- ============================================================================
-- 5. ZEIT-FORMATIERER (Wandelt Sekunden in 0:00 um)
-- ============================================================================
local function FormatFlightTime(seconds)
    local m = math.floor(seconds / 60)
    local s = math.floor(seconds % 60)
    return string.format("%d:%02d", m, s)
end

-- Interne Triangulations-Variablen
local isFlying = false
local startTime = 0
local totalDuration = 0
local currentRouteKey = "Unknown"
-- ============================================================================
-- RankoneQoL - Modul: Sci-Fi Flight Time Left Tracker - TEIL 2 von 2 (Engine & Events)
-- ============================================================================

-- ============================================================================
-- 6. DYNAMISCHE TICK-ENGINE (Berechnet jede Sekunde den Füllstand)
-- ============================================================================
local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", function(self, elapsed)
    if not isFlying then return end
    
    local currentTime = GetTime()
    local elapsedFlightTime = currentTime - startTime
    
    -- Sync die Optik fortlaufend live mit dem aktiven Farb-Theme
    SyncTimerColorWithActiveTheme()
    
    if totalDuration > 0 then
        -- ROUTE BEKANNT: Countdown berechnen
        local timeLeft = math.max(0, totalDuration - elapsedFlightTime)
        local progress = math.min(1, elapsedFlightTime / totalDuration)
        
        -- Millimetergenaue Anpassung der Füllleiste (178px maximale Innenbreite)
        FlightTimerFrame.bar:SetWidth(178 * progress)
        FlightTimerFrame.text:SetText(string.format("ETA: %s", FormatFlightTime(timeLeft)))
        
        -- Sicherheitsabschaltung, falls der Timer vor der Landung ablöuft
        if timeLeft <= 0 then
            FlightTimerFrame.text:SetText("Arriving...")
        end
    else
        -- ROUTE UNBEKANNT: Lernmodus aktivieren
        FlightTimerFrame.bar:SetWidth(178) -- Balken blinkt voll im Theme-Glow
        FlightTimerFrame.text:SetText(string.format("Learning Route... (%s)", FormatFlightTime(elapsedFlightTime)))
    end
end)

-- ============================================================================
-- 7. EVENT CORE TRIGGER (Abfangen von Flugbeginn und Landung)
-- ============================================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_CONTROL_LOST")
eventFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
eventFrame:RegisterEvent("TAXIMAP_OPENED")

-- Hilfsvariable, um den Zielnamen direkt von der Flugkarte abzugreifen
local lastSelectedNodeName = nil

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if not RankoneQoL_Profile then return end
    
    -- A) Merkt sich das angeklickte Ziel, wenn die Flugkarte geöffnet war
    if event == "TAXIMAP_OPENED" then
        hooksecurefunc("TakeTaxiNode", function(slot)
            if NumTaxiNodes() >= slot then
                lastSelectedNodeName = TaxiNodeName(slot)
            end
        end)
        
    -- B) FLUG STARTET: Spieler verliert die Kontrolle und sitzt auf dem Taxi
    elseif event == "PLAYER_CONTROL_LOST" then
        -- 1 Millisekunde Puffer, damit der Client den Zustand "UnitOnTaxi" sauber setzt
        C_Timer.After(0.05, function()
            if UnitOnTaxi("player") then
                isFlying = true
                startTime = GetTime()
                
                -- Routen-Schlüssel generieren (z. B. "Ironforge to Stormwind")
                local startZone = GetMinimapZoneText() or "Unknown"
                local endZone = lastSelectedNodeName or "Unknown Destination"
                currentRouteKey = string.format("%s to %s", startZone, endZone)
                
                -- Schaut im Datenbank-Tresor nach, ob die Strecke bekannt ist
                if RankoneQoL_Profile.flightTimes and RankoneQoL_Profile.flightTimes[currentRouteKey] then
                    totalDuration = RankoneQoL_Profile.flightTimes[currentRouteKey]
                else
                    totalDuration = 0 -- Lernmodus anwerfen
                end
                
                SyncTimerColorWithActiveTheme()
                FlightTimerFrame:Show()
            end
        end)
        
    -- C) LANDUNG: Spieler erhält die Kontrolle zurück
    elseif event == "PLAYER_CONTROL_GAINED" then
        if isFlying then
            isFlying = false
            local endTime = GetTime()
            local finalDuration = endTime - startTime
            
            -- Wenn die Route neu war UND der Flug länger als 10 Sekunden dauerte (Sicherheit)
            if totalDuration == 0 and finalDuration > 10 and currentRouteKey ~= "Unknown" then
                if not RankoneQoL_Profile.flightTimes then RankoneQoL_Profile.flightTimes = {} end
                -- Speichert die exakte Flugzeit permanent im Charakterprofil ab
                RankoneQoL_Profile.flightTimes[currentRouteKey] = math.floor(finalDuration)
            end
            
            -- Weiches Ausblenden der HUD-Anzeige
            FlightTimerFrame:Hide()
            lastSelectedNodeName = nil
            currentRouteKey = "Unknown"
        end
    end
end)
