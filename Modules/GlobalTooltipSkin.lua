-- ============================================================================
-- RankoneQoL - Modul: Global Tooltip Skin & Vendor Values (Theme-Engine Enhanced)
-- ============================================================================

local L = RankoneQoL_Locals

-- ============================================================================
-- 1. CENTRAL MONEY FORMATTER
-- ============================================================================
local function FormatTooltipMoney(totalCopper)
    if not totalCopper or totalCopper <= 0 then return nil end
    local gold = math.floor(totalCopper / 10000)
    local silver = math.floor((totalCopper - (gold * 10000)) / 100)
    local copper = totalCopper % 100
    
    local result = ""
    if gold > 0 then result = result .. gold .. " |TInterface\\MoneyFrame\\UI-GoldIcon:0|t " end
    if silver > 0 then result = result .. silver .. " |TInterface\\MoneyFrame\\UI-SilverIcon:0|t " end
    if copper > 0 or result == "" then result = result .. copper .. " |TInterface\\MoneyFrame\\UI-CopperIcon:0|t" end
    return result
end

-- ============================================================================
-- 2. DYNAMISCHE HÄNDLERPREIS-INJEKTION
-- ============================================================================
local function InjectVendorValue(tooltip)
    if not tooltip or tooltip:IsForbidden() then return end
    local _, link = tooltip:GetItem()
    if not link then return end
    
    local _, _, _, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(link)
    if not itemSellPrice or itemSellPrice <= 0 then return end
    
    local owner = tooltip:GetOwner()
    local stackCount = 1
    
    if owner and owner.GetID then
        local bag = owner:GetParent():GetID()
        local slot = owner:GetID()
        if bag and slot and type(bag) == "number" and type(slot) == "number" then
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.stackCount then
                stackCount = info.stackCount
            end
        end
    end
    
    if stackCount > 1 then
        local totalFormatted = FormatTooltipMoney(itemSellPrice * stackCount)
        if totalFormatted then
            local label = string.format(L["TOOLTIP_STACK_VALUE"], stackCount)
            tooltip:AddDoubleLine("|cFFBBBBBB" .. label .. "|r", totalFormatted)
        end
    else
        local singleFormatted = FormatTooltipMoney(itemSellPrice)
        if singleFormatted then
            tooltip:AddDoubleLine("|cFFBBBBBB" .. L["TOOLTIP_SELL_VALUE"] .. "|r", singleFormatted)
        end
    end
end

-- ============================================================================
-- 3. GLOBAL SCI-FI SKIN ENGINE (Dynamische Anpassung an das gewählte Theme)
-- ============================================================================
local function ApplySciFiSkin(tooltip)
    if not tooltip or tooltip:IsForbidden() then return end
    
    -- Blizzards standardmäßige Kanten unsichtbar machen
    if tooltip.NineSlice then 
        tooltip.NineSlice:SetAlpha(0) 
    end
    
    -- Holt die aktuellen Theme-Farbwerte live aus dem Datentresor
    local currentThemeKey = RankoneQoL_Profile and RankoneQoL_Profile.menuTheme or "neon_cyan"
    local c = nil
    if RankoneQoL_MenuThemes then
        for _, theme in ipairs(RankoneQoL_MenuThemes) do
            if theme.key == currentThemeKey then c = theme break end
        end
    end
    -- Fallback-Farbe (Cyan), falls der Tresor noch nicht geladen ist
    if not c then
        c = { bgR = 0.01, bgG = 0.01, bgB = 0.01, bgAlpha = 0.85, borderR = 0.15, borderG = 0.15, borderB = 0.15, borderAlpha = 0.9, accentR = 0.0, accentG = 0.75, accentB = 1.0, accentAlpha = 1.0 }
    end
    
    -- Eigene abgerundete Kachel erstellen, falls sie noch nicht existiert
    if not tooltip.RankoneBG then
        local bg = CreateFrame("Frame", nil, tooltip, "BackdropTemplate")
        bg:SetFrameStrata("TOOLTIP")
        bg:SetFrameLevel(tooltip:GetFrameLevel() - 1)
        
        bg:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 14,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        
        bg:SetPoint("TOPLEFT", tooltip, "TOPLEFT", -4, 4)
        bg:SetPoint("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT", 4, -4)
        tooltip.RankoneBG = bg

        -- HEADER BACKGROUND HIGHLIGHT (Hauchzarter Schimmer oben)
        local headerHighlight = bg:CreateTexture(nil, "BACKGROUND")
        headerHighlight:SetHeight(25)
        headerHighlight:SetPoint("TOPLEFT", bg, "TOPLEFT", 4, -4)
        headerHighlight:SetPoint("TOPRIGHT", bg, "TOPRIGHT", -4, -4)
        tooltip.RankoneHeaderHighlight = headerHighlight

        -- HORIZONTALE GLOW-TRENNLINIE
        local line = bg:CreateTexture(nil, "ARTWORK")
        line:SetHeight(1)
        line:SetPoint("TOPLEFT", bg, "TOPLEFT", 14, -28)
        line:SetPoint("TOPRIGHT", bg, "TOPRIGHT", -14, -28)
        line:SetColorTexture(1, 1, 1, 1) 
        tooltip.RankoneLine = line
    end
    
    -- DYNAMISCHES LIVE-UMFÄRBEN BEI JEDEM AUFRUF
    tooltip.RankoneBG:SetBackdropColor(c.bgR, c.bgG, c.bgB, c.bgAlpha) 
    tooltip.RankoneBG:SetBackdropBorderColor(c.accentR, c.accentG, c.accentB, 0.8) -- Kante leuchtet im Theme-Akzent!
    
    tooltip.RankoneHeaderHighlight:SetColorTexture(c.accentR, c.accentG, c.accentB, 0.03)
    
    -- Invertierte Fading-Engine anpassen (Außen Theme-Farbe, verblasst in der Mitte)
    tooltip.RankoneLine:SetGradient("HORIZONTAL", 
        CreateColor(c.accentR, c.accentG, c.accentB, 0.5),
        CreateColor(c.accentR, c.accentG, c.accentB, 0.0),
        CreateColor(c.accentR, c.accentG, c.accentB, 0.5)
    )
    
    tooltip.RankoneBG:Show()
    tooltip.RankoneHeaderHighlight:Show()
    tooltip.RankoneLine:Show()
end

local function RemoveSciFiSkin(tooltip)
    if tooltip and tooltip.RankoneBG then
        tooltip.RankoneBG:Hide()
        if tooltip.RankoneHeaderHighlight then tooltip.RankoneHeaderHighlight:Hide() end
        if tooltip.RankoneLine then tooltip.RankoneLine:Hide() end
    end
end

-- ============================================================================
-- 4. HOOKS REGISTRIEREN
-- ============================================================================
local tooltipsToSkin = {
    GameTooltip,
    ItemRefTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2,
}

for _, tooltip in ipairs(tooltipsToSkin) do
    if tooltip then
        tooltip:HookScript("OnTooltipSetItem", InjectVendorValue)
        tooltip:HookScript("OnUpdate", ApplySciFiSkin)
        tooltip:HookScript("OnHide", RemoveSciFiSkin)
    end
end
