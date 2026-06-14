-- ============================================================================
-- RankoneQoL - Zentraler Font-Speicher (Font Storage)
-- ============================================================================

RankoneQoL_Fonts = {
    { name = "WoW Friz Quadrata",    path = "Fonts\\FRIZQT__.TTF" },
    { name = "WoW Arial Narrow",     path = "Fonts\\ARIALN.TTF" },
    { name = "WoW Morpheus",         path = "Fonts\\MORPHEUS.TTF" },
    { name = "WoW Skurri",           path = "Fonts\\SKURRI.TTF" },
    { name = "WoW Damage / Combat",  path = "Fonts\\2002.TTF" },
    { name = "WoW PT Sans Narrow",   path = "Fonts\\PTSansNarrow.TTF" },
}

function RankoneQoL_GetFontPath(fontName)
    for _, fontData in ipairs(RankoneQoL_Fonts) do
        if fontData.name == fontName then
            return fontData.path
        end
    end
    return "Fonts\\FRIZQT__.TTF"
end
