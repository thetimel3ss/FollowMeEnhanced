--
-- FollowMe Enhanced 1.2b
-- by Lyriane of EU-Alleria
-- based on FollowMe 1.1.1a by Kinyen (Kingen in inherited header)
--
-- Follow-only fixes: persistent enabled state, safer authorization,
-- command parsing, target restoration, and scoped follow error reports.
-- See ReadMe.txt for documentation.
--

-- Local runtime state (the global FollowMe_Options is a SavedVariable).
local following = nil
local pendingFollow = nil
local FMEnabled = true
local FMVer = "1.2b"
local tellgrp, tellraid, followguild, followfriends

local function FollowMe_EnabledText(enabled)
   if enabled then
      return FM_STATUS_ENABLED
   end
   return FM_STATUS_DISABLED
end

local function FollowMe_GroupText(enabled)
   if enabled then
      return FM_GROUP_ON
   end
   return FM_GROUP_OFF
end

function FollowMe_LocalMsg(txt)
   DEFAULT_CHAT_FRAME:AddMessage(txt)
end

-- Keep all persistent settings in one table for the options UI.
-- Existing installations retain the four original option keys.
function FollowMe_InitOptions()
   if type(FollowMe_Options) ~= "table" then
      FollowMe_Options = {}
   end

   if type(FollowMe_Options["Enabled"]) ~= "boolean" then
      FollowMe_Options["Enabled"] = true
   end

   -- Backward-compatible migration: the previous AllowParty setting
   -- authorized both party and raid. Seed AllowRaid once from that
   -- existing permission before making the two settings independent.
   if type(FollowMe_Options["AllowParty"]) ~= "boolean" then
      FollowMe_Options["AllowParty"] = true
   end
   if type(FollowMe_Options["AllowRaid"]) ~= "boolean" then
      FollowMe_Options["AllowRaid"] = FollowMe_Options["AllowParty"]
   end
   local keys = { "Raid", "Group", "FollowFriends", "FollowGuild" }
   for i = 1, table.getn(keys) do
      local key = keys[i]
      if type(FollowMe_Options[key]) ~= "boolean" then
         FollowMe_Options[key] = false
      end
   end

   FMEnabled = FollowMe_Options["Enabled"]
   tellgrp = FollowMe_GroupText(FollowMe_Options["Group"])
   tellraid = FollowMe_GroupText(FollowMe_Options["Raid"])
   followguild = FollowMe_EnabledText(FollowMe_Options["FollowGuild"])
   followfriends = FollowMe_EnabledText(FollowMe_Options["FollowFriends"])
end

local FOLLOW_SETTINGS = {
   Enabled = true, AllowParty = true, AllowRaid = true,
   Group = true, Raid = true,
   FollowFriends = true, FollowGuild = true
}

function FME_SetOption(key, enabled)
   if not FOLLOW_SETTINGS[key] or type(enabled) ~= "boolean" then return end
   FollowMe_InitOptions()
   FollowMe_Options[key] = enabled
   FollowMe_InitOptions()
   if type(FME_RefreshOptions) == "function" then FME_RefreshOptions() end
end

function FME_GetFollowStatus()
   return following
end

function FollowMe_SendWhisper(name, message)
   if type(name) == "string" and name ~= "" and type(message) == "string" and message ~= "" then
      SendChatMessage(message, "WHISPER", nil, name)
   end
end

local function FollowMe_ShowHelp()
   FollowMe_LocalMsg("FollowMeEnhanced v" .. FMVer .. " - Commands:")
   FollowMe_LocalMsg("  /fm                    - Open options")
   FollowMe_LocalMsg("  /fm help               - Show this command list")
   FollowMe_LocalMsg("  /fm config             - Open options (alias: options)")
   FollowMe_LocalMsg("  /fm status             - Show follow and announcement status")
   FollowMe_LocalMsg("  /fm party | raid       - Explain the addon in group chat")
   FollowMe_LocalMsg("  /fm whisper            - Explain the addon to your target")
   FollowMe_LocalMsg("  Whisper: @follow or @status")
end

function FollowMe_OnLoad()
   local message = "FollowMeEnhanced " .. FMVer .. " loaded"
   SLASH_FOLLOWME1 = "/fm"
   SLASH_FOLLOWME2 = "/followme"
   SlashCmdList["FOLLOWME"] = FollowMe_CmdParser

   FollowMe_LocalMsg(message)
   UIErrorsFrame:AddMessage(message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME)

   -- Do not initialize SavedVariables before VARIABLES_LOADED.
   this:RegisterEvent("VARIABLES_LOADED")
   this:RegisterEvent("CHAT_MSG_WHISPER")
   this:RegisterEvent("UI_ERROR_MESSAGE")
   this:RegisterEvent("AUTOFOLLOW_BEGIN")
   this:RegisterEvent("AUTOFOLLOW_END")
end

-- /fm and /followme local commands.
function FollowMe_CmdParser(parm)
   FollowMe_InitOptions()

   local raw = parm or ""
   local text = string.lower(raw)
   local _, _, cmd, option = string.find(text, "^%s*(%S+)%s*(.-)%s*$")

   if not cmd or cmd == "config" or cmd == "options" then
      if type(FME_ToggleOptions) == "function" then
         FME_ToggleOptions()
      else
         FollowMe_LocalMsg("FollowMeEnhanced: Options UI unavailable.")
      end
      return
   end

   if cmd == "help" then
      FollowMe_ShowHelp()
      return
   end

   if cmd == FM_COMMAND_STATUS then
      FollowMe_LocalMsg("FollowMeEnhanced: " .. FollowMe_EnabledText(FMEnabled))
      FollowMe_LocalMsg(FM_STATUS_GROUP .. tellgrp .. ".")
      FollowMe_LocalMsg(FM_STATUS_RAID .. tellraid .. ".")
      FollowMe_LocalMsg(FM_STATUS_GUILD .. followguild .. ".")
      FollowMe_LocalMsg(FM_STATUS_FRIENDS .. followfriends .. ".")
      FollowMe_LocalMsg("   Party follow requests: " ..
         FollowMe_EnabledText(FollowMe_Options["AllowParty"]))
      FollowMe_LocalMsg("   Raid follow requests: " ..
         FollowMe_EnabledText(FollowMe_Options["AllowRaid"]))
      if following then
         FollowMe_LocalMsg(FM_WHISPER_STATUS_FOLLOW .. following)
      end
      return
   end

   if cmd == FM_COMMAND_ANNOUNCE then
      if GetNumPartyMembers() > 0 then
         SendChatMessage(FM_ANNOUNCE, "PARTY")
      end
      return
   end

   if cmd == FM_COMMAND_RAID then
      if GetNumRaidMembers() > 0 then
         SendChatMessage(FM_ANNOUNCE, "RAID")
      end
      return
   end

   if cmd == FM_COMMAND_TARGET then
      if UnitExists("target") and UnitIsPlayer("target") then
         FollowMe_SendWhisper(UnitName("target"), FM_ANNOUNCE)
      else
         FollowMe_LocalMsg(FM_ERR_NO_PLAYER_TARGET)
      end
      return
   end

   FollowMe_ShowHelp()
end

-- Independent authorizations for party, raid, friends and guild members.
function FollowMe_InMyGroup(name)
   if type(name) ~= "string" or name == "" then
      return false
   end

   if name == UnitName("player") then
      return true
   end

   -- Party permission is only effective outside a raid. Even if a
   -- custom client exposes party units while raiding, they must not
   -- bypass the separate raid permission.
   local numRaid = GetNumRaidMembers()
   if numRaid > 0 then
      if FollowMe_Options["AllowRaid"] then
         for i = 1, numRaid do
            if name == UnitName("raid" .. i) then
               return true
            end
         end
      end
   elseif FollowMe_Options["AllowParty"] then
      local numParty = GetNumPartyMembers()
      for i = 1, numParty do
         if name == UnitName("party" .. i) then
            return true
         end
      end
   end

   if FollowMe_Options["FollowFriends"] then
      for i = 1, GetNumFriends() do
         if name == GetFriendInfo(i) then
            return true
         end
      end
   end

   if FollowMe_Options["FollowGuild"] and IsInGuild() then
      for i = 1, GetNumGuildMembers() do
         if name == GetGuildRosterInfo(i) then
            return true
         end
      end
   end

   return false
end

local function FollowMe_RestoreTarget(originalTarget)
   if originalTarget then
      if UnitName("target") ~= originalTarget then
         TargetLastTarget()
      end
   elseif UnitExists("target") then
      ClearTarget()
   end
end

-- Called by CHAT_MSG_WHISPER. Only exact @follow and @status are accepted.
function FollowMe_ProcessWhisper(whisper, requester)
   if type(whisper) ~= "string" or type(requester) ~= "string" or requester == "" then
      return
   end

   -- No pattern-based execution of arbitrary commands or macro text.
   local _, _, command = string.find(string.lower(whisper), "^%s*(%S+)%s*$")
   if command == FM_WHISPERCOMMAND_FOLLOW then
      FollowMe_InitOptions()
      if not FMEnabled then
         FollowMe_SendWhisper(requester, FM_WHISPER_DISABLED)
         return
      end
      if not FollowMe_InMyGroup(requester) then
         FollowMe_SendWhisper(requester, FM_ERR_NOGROUP)
         return
      end

      local originalTarget = nil
      if UnitExists("target") then
         originalTarget = UnitName("target")
      end

      TargetByName(requester, true)
      if UnitName("target") == requester then
         -- Errors during this short window can be attributed to a follow
         -- request; unrelated UI errors must never whisper the last sender.
         pendingFollow = { name = requester, expires = GetTime() + 2 }
         FollowUnit("target")
      else
         FollowMe_SendWhisper(requester, FM_ERR_GENERIC)
      end
      FollowMe_RestoreTarget(originalTarget)
      return
   end

   if command == FM_WHISPERCOMMAND_STATUS then
      FollowMe_InitOptions()
      local response = "FollowMeEnhanced (" .. FMVer .. "): " .. FollowMe_EnabledText(FMEnabled)
      if FMEnabled and following then
         response = response .. FM_WHISPER_STATUS_FOLLOW .. following
      end
      FollowMe_SendWhisper(requester, response)
   end
end

function FollowMe_OnEvent(event)
   if event == "VARIABLES_LOADED" then
      FollowMe_InitOptions()
      return
   end

   if event == "CHAT_MSG_WHISPER" then
      if arg1 and arg2 then
         FollowMe_ProcessWhisper(arg1, arg2)
      end
      return
   end

   if event == "UI_ERROR_MESSAGE" then
      if pendingFollow then
         local request = pendingFollow
         if GetTime() > request.expires then
            pendingFollow = nil
         elseif arg1 == ERR_AUTOFOLLOW_TOO_FAR or arg1 == ERR_INVALID_FOLLOW_TARGET then
            pendingFollow = nil
            if arg1 == ERR_AUTOFOLLOW_TOO_FAR then
               FollowMe_SendWhisper(request.name, FM_ERR_AUTOFOLLOW_TOO_FAR)
            else
               FollowMe_SendWhisper(request.name, FM_ERR_INVALID_FOLLOW_TARGET)
            end
         end
      end
      return
   end

   if event == "AUTOFOLLOW_BEGIN" then
      local newFollowing = arg1
      if (not newFollowing or newFollowing == "") and pendingFollow then
         newFollowing = pendingFollow.name
      end
      pendingFollow = nil
      following = newFollowing
      if type(FME_RefreshOptions) == "function" then FME_RefreshOptions() end
      if following and following ~= "" then
         FollowMe_SendWhisper(following, FM_WHISPER_AUTOFOLLOW_BEGIN)
         if tellgrp == FM_GROUP_ON and GetNumPartyMembers() > 0 then
            SendChatMessage(FM_PARTY_AUTOFOLLOW_BEGIN .. following, "PARTY")
         elseif tellraid == FM_GROUP_ON and GetNumRaidMembers() > 0 then
            SendChatMessage(FM_PARTY_AUTOFOLLOW_BEGIN .. following, "RAID")
         end
      end
      return
   end

   if event == "AUTOFOLLOW_END" then
      pendingFollow = nil
      if following and following ~= "" then
         FollowMe_SendWhisper(following, FM_WHISPER_AUTOFOLLOW_END)
         if tellgrp == FM_GROUP_ON and GetNumPartyMembers() > 0 then
            SendChatMessage(FM_PARTY_AUTOFOLLOW_END .. following, "PARTY")
         elseif tellraid == FM_GROUP_ON and GetNumRaidMembers() > 0 then
            SendChatMessage(FM_PARTY_AUTOFOLLOW_END .. following, "RAID")
         end
      end
      following = nil
      if type(FME_RefreshOptions) == "function" then FME_RefreshOptions() end
   end
end
