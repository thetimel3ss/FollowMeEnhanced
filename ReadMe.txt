================================================================
FollowMe Enhanced - Follow-only edition (Vanilla WoW 1.12.1)
================================================================

This edition starts from the original master branch and includes
only the follow fixes and the options UI. Remote spell casting,
@assist, macro execution, Nampower diagnostics, and cast tests
are intentionally absent. Experimental history remains on the
separate local-changes branch.

OPEN OPTIONS
  /fm
  /followme
  /fm config
  /fm options

HELP
  /fm help

SUPPORTED WHISPER COMMANDS (case-insensitive; exact match):
  @follow  - Requests that the recipient follow the sender
  @status  - Requests the recipient's addon/follow status

LOCAL COMMANDS
  /fm status
  /fm enable
  /fm disable
  /fm friends on/off
  /fm guild on/off
  /fm tellgroup on/off
  /fm tellraid on/off
  /fm party
  /fm raid
  /fm whisper
  /fm help
  /fm config / options

OPTIONS UI
  Enable remote follow
  Allow friends to request follow
  Allow guild members to request follow
  Announce auto-follow changes in party
  Announce auto-follow changes in raid

FOLLOW CORRECTIONS
  - Enabled/disabled persists through SavedVariables.
  - Exact whisper command parsing; other commands are ignored.
  - Permission check: party/raid by default; friends/guild if enabled.
  - Follow attempts restore the previous target or clear a temporary
    selection when there was no target.
  - Follow-related UI errors are attributed only to a recent
    @follow request, not to the latest unrelated whisper.
  - A real AUTOFOLLOW_BEGIN/AUTOFOLLOW_END event drives
    notifications; party announcements take precedence over raid.
  - /fm tellraid off correctly saves false.
  - /fm whisper verifies that a player is targeted.
  - The follow panel uses Vanilla widgets with Lua 5.0 compatibility.
  - Old German localization and ReadMe-de were removed by request.

Compatibility:
  WoW 1.12.1 client; ClassicAPI is not required.
  English-only interface and messages.
  Prior experimental Remote* SavedVariables may remain in the user's
  saved settings, but are not read or used by this edition.

NOTE
  For accepted @follow requests, the addon targets the sender,
  calls FollowUnit("target") and restores the previous selection.
  If the client refuses the action, errors may still be delivered
  by the base client; the addon does not bypass client restrictions.

================================================================
HISTORICAL README FROM THE ORIGINAL ADDON
(The following text describes the original release and may contain
 outdated commands; use the instructions above for this edition.)
================================================================
================================================================
Version 1.2b

 - new command

Guild members and friends
 - new command:
  "/fm whisper"   - announces to your current target that you have this AddOn.

================================================================
Version 1.1b

 - Added support for guild members and friends
 - Minor bug fixes

Guild members and friends
 - new commands:
  "/fm guild on/off"   - Toggles that guild members can put you in auto-follow
  "/fm friends on/off" - Toggles that friends can put you in auto-follow

================================================================
Version 1.0b

 - Added support for SavedVariables
 - Added raid support
 - Added localization support (including german and english)
 - Minor code modifications (pure cosmetic)


Localization support:
 - All text strings for output
 - Keywords to put you on auto-follow
 - Keywords to configure FollowMe Enhanced


================================================================
FollowMe Enhanced - Changes made by Lyriane (addons@we-go-mc.de) ================================================================


FollowMe 1.11
Author: Kinyen (druidkinyen@hotmail.com)

This AddOn allows party members to put you on auto-follow.  Most useful
when people suddenly go AFK without telling anyone.  Normally, players
can auto-follow any other player, but since this AddOn allows other
people to control you, it will only allow members of your party to put
you on auto-follow.

FollowMe is different from FollowTheLeader in that it requires the follow
commands to be at the beginning of whisper (i.e. "!follow").  That way if
someone is whispering directions to you like "All you do is follow the
path south", you won't automatically start following them. :)

The following commands are supported:
  "/fm announce"           - announces to your party that you have this AddOn.
  "/fm enable"             - Allows others to put you on auto-follow.
  "/fm disable"            - Does not allow others to put you on auto-follow.
  "/fm tellgroup [on | off]- Turns on (or off) the sending of auto-follow
                             messages to your group.
  "/fm status"             - Reports the status of FollowMe (enabled,
                             disabled, who is being followed).

The received whisper can be one of:
   "#follow" - Puts auto-follow on the whisper sender
   "#status" - whispers the status (enabled/disabled) to the sender.
               if following, will report who is being followed.

NOTES:  Auto-follow is exclusive.  That is, you can be put
        on auto-follow regardless of what you are doing
        (i.e. tradeskills, casting spells, in the bank, etc).
        Auto-Follow will cancel these operations.

        The only way to cancel auto-follow is for the "following" person
        to press a directional key.  As of update 1.6, all movement
        functions  are ignored unless triggered by pressing a key.
        There is no longer any way to stop auto-following under script
        control.

        The "disable" and "enable" commands do not really disable the AddOn.
        They simply tell the addon to allow or not allow someone to put
        you on auto-follow.


What's new in 1.11
==================
 - Fixed an annoying bug that incorrectly reported non-grouped players
   as being "too far away".  More cosmetic than anything but it was annoying
   me. :)

 - Added version number in all messages (!status, /fm status, etc).  This way when
   another player /whispers !status to you, FollowMe will respond with the version 
   number as well.

Changes in 1.1
==================
 - Fixed scripting error that occurred while trying to loot or harvest
   items that are too far away.

 - Current target is retained when going on auto-follow.

 - Typing "/fm" by itself now generates a usage message.

 - added "/fm tellgroup on | off" (default on) to tell the group
   start/stop follow messages.  Messages are always whispered to the "followed"
   player.

---------------------------------------------------------------------------------
If you have any comments or suggestions or find any bugs, please don't
hesitate to contact me at "druidkinyen@hotmail.com".

