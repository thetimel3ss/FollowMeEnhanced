--Commands
FM_GROUP_ON = "on";
FM_GROUP_OFF = "off";
FM_WHISPERCOMMAND_FOLLOW = "@follow";
FM_WHISPERCOMMAND_STATUS = "@status";
FM_COMMAND_STATUS = "status";
FM_COMMAND_ANNOUNCE = "party";
FM_COMMAND_RAID = "raid";
FM_COMMAND_TARGET = "whisper";

--Status
FM_STATUS_LOADED = "loaded";
FM_STATUS_ENABLED = "Enabled";
FM_STATUS_DISABLED = "Disabled";
FM_STATUS_GROUP = "   Group messages are ";
FM_STATUS_RAID = "   Raid messages are ";
FM_STATUS_GUILD = "   Accept auto-follow requests by guild members is ";
FM_STATUS_FRIENDS = "   Accept auto-follow requests by friends is ";

--Tellgroup
FM_TELLGROUP = "FollowMeEnhanced: Group messages are ";
FM_TELLRAID = "FollowMeEnhanced: Raid messages are ";
FM_FOLLOWGUILD = "FollowMeEnhanced: Accept auto-follow requests by guild members is ";
FM_FOLLOWFRIENDS = "FollowMeEnhanced: Accept auto-follow requests by friends is ";

--Event messages
FM_ERR_AUTOFOLLOW_TOO_FAR = "I cannot follow you.  Perhaps you're not close enough?";
FM_ERR_INVALID_FOLLOW_TARGET = "I cannot follow you.  Perhaps you're not close enough?";
FM_ERR_GENERIC = "I cannot follow you.  Perhaps you're not close enough?";
FM_ERR_NOGROUP = "I cannot follow you -- your character is not authorized in my follow settings.";
FM_ERR_NO_PLAYER_TARGET = "FollowMeEnhanced: Select a player before using /fm whisper.";
FM_WHISPER_AUTOFOLLOW_BEGIN = "Following you...lead on :)";
FM_PARTY_AUTOFOLLOW_BEGIN = "Auto-follow on ";
FM_WHISPER_AUTOFOLLOW_END = "I'm no longer following you.";
FM_PARTY_AUTOFOLLOW_END = "I'm no longer auto-following ";
FM_WHISPER_DISABLED = "I can't follow you -- FollowMe addon is disabled";
FM_WHISPER_STATUS_FOLLOW = "  Currently following ";

--Announce
FM_ANNOUNCE = [[I have the "FollowMeEnhanced" AddOn Installed.  If you want me to auto-follow you, send me a whisper with "]]..FM_WHISPERCOMMAND_FOLLOW..[[".]]..[[ For the actual status use "]]..FM_WHISPERCOMMAND_STATUS..[["."]];
