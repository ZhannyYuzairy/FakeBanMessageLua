local js = require("access_panorama") 
local function collect_keys(tbl, sort)
    local keys = {}
    sort = sort or true
    for k in pairs(tbl) do
        keys[#keys + 1] = k
    end
    if sort then
        table.sort(keys)
    end
    return keys
end
local ban_reason = {
	["Abandon"] = "#SFUI_CooldownExplanationReason_Abandon",
	["Resolving MM state account"] = "#SFUI_CooldownExplanationReason_Abandon_Grace",
	["Greif"] = "#SFUI_CooldownExplanationReason_ConvictedForBehavior",
	["Cheating"] = "#SFUI_CooldownExplanationReason_ConvictedForCheating",
	["Disconnected for too long"] = "#SFUI_CooldownExplanationReason_DisconnectedTooLong",
	["Resolving MM State Match"] = "#SFUI_CooldownExplanationReason_DisconnectedTooLong_Grace",
	["Failed to connect"] = "#SFUI_CooldownExplanationReason_FailedToConnect",
	["Server token violation"] = "#SFUI_CooldownExplanationReason_GsltViolation",
	["Kick Abuse"] = "#SFUI_CooldownExplanationReason_KickAbuse",
	["Kicked"] = "#SFUI_CooldownExplanationReason_Kicked",
	["Kicked too much"] = "#SFUI_CooldownExplanationReason_KickedTooMuch",
	["Offical Ban"] = "#SFUI_CooldownExplanationReason_OfficialBan",
	["Skill group Calibration"] = "#SFUI_CooldownExplanationReason_SkillGroupCalibration",
	["Damage"] = "#SFUI_CooldownExplanationReason_TH_Limit",
	["Damage on spawn"] = "#SFUI_CooldownExplanationReason_TH_Spawn",
	["Team killing"] = "#SFUI_CooldownExplanationReason_TK_Limit",
	["Spawn killing"] = "#SFUI_CooldownExplanationReason_TK_Spawn"
}
local ban_type = {
	["Global"] = "global",
	["Temp"] = "green",
	["Competitive"] = "competitive"
}
local VACCheckbox = ui.new_checkbox("LUA", "A", "Fake VAC ban")
local LengthDays = ui.new_slider("LUA","A", "Ban length in days", 0, 49, 1)
local LengthMins = ui.new_slider("LUA","A", "Ban length in minutes", 0, 60, 1)
local LengthSeconds = ui.new_slider("LUA","A", "Ban length in seconds", 0, 60, 1)
local Reason = ui.new_combobox("lua", "A", "Reason for ban", collect_keys(ban_reason))
local bantype = ui.new_combobox("lua", "A", "Type for ban", collect_keys(ban_type))

local function applyban()
   js.eval([[
   	CompetitiveMatchAPI.GetCooldownType = function() {return "]]..ban_type[ui.get(bantype)]..[["}
   	CompetitiveMatchAPI.GetCooldownReason = function() {return "]]..ban_reason[ui.get(Reason)]..[["}
   	CompetitiveMatchAPI.GetCooldownSecondsRemaining = function() {return ]]..ui.get(LengthDays) * 86400 + ui.get(LengthMins) *60 + ui.get(LengthSeconds) ..[[}]])
end
local function updateVAC()
	 js.eval([[MyPersonaAPI.IsVacBanned = function() {return ]] ..tostring(ui.get(VACCheckbox))	..[[}]])
end
ui.set_callback(VACCheckbox, updateVAC)

local button = ui.new_button("LUA","A","Apply Ban", applyban)
