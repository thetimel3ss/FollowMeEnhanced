================================================================
FollowMe Enhanced v1.3.0 - Follow-only edition (Vanilla WoW 1.12.1)
================================================================

No remote cast, @assist, macro execution or Nampower integration.

RELEASE NOTES - v1.3.0
  - Adds a movable options UI with seven persistent checkboxes and tooltips.
  - Separates party and raid follow permissions while preserving prior settings.
  - Accepts authorized @follow requests via FollowByName without changing target.
  - Retains @status, follow start/end notifications and scoped error handling.
  - Consolidates English localization; removes unused experimental features.
  - Based on Lyriane's FollowMe Enhanced v1.2b and Kinyen's original FollowMe.

LOCAL COMMANDS
  /fm                - Open or close the options UI
  /followme           - Open or close the options UI
  /fm config          - Open or close the options UI
  /fm options         - Open or close the options UI
  /fm help            - List active commands in chat
  /fm status          - Report enabled, permission and announce status
  /fm party           - Explain addon usage in party chat
  /fm raid            - Explain addon usage in raid chat
  /fm whisper         - Explain addon usage to a targeted player

Settings are controlled exclusively through the options UI.
The old /fm enable, disable, guild, friends, tellgroup, and tellraid
commands are no longer accepted.

WHISPER COMMANDS (exact, case-insensitive)
  @follow             - Request that the recipient follow the sender
  @status             - Request the recipient's addon status

OPTIONS UI - REMOTE FOLLOW
  Enable              - Master follow switch, on by default.
  Allow friends       - Allow players on your friends list; off by default.
  Allow guildmates    - Allow your guild members; off by default.
  Allow party         - Allow party members only, not raid; on by default.
  Allow raid          - Allow raid members only; on by default. For an
                        existing install, its initial value is copied
                        from the old AllowParty setting once, then
                        both permissions are independent.

  Checkbox placement:
     Allow friends           Allow guildmates
     Allow party             Allow raid

OPTIONS UI - ANNOUNCEMENTS
  Party               - Announce when following starts or ends in party.
  Raid                - Announce when following starts or ends in raid.
                        Party notifications take priority if both apply.

Each of the seven checkboxes has a tooltip explaining its function;
the labels are also hoverable and clickable.

FOLLOW FIXES
  - Exact whisper matching and independent party/raid permissions.
  - Persistent settings for all seven options.
  - Follows the whisper sender via FollowByName, without changing target.
  - Associates client UI errors only with recent follow attempts.
  - Sends follow announcements after AUTOFOLLOW_BEGIN or END.
  - Vanilla 1.12.1 Lua 5.0 compatible; ClassicAPI not required.
  - German localization removed by request.

HISTORICAL CREDITS
  Lyriane of EU-Alleria: FollowMe Enhanced v1.2b.
  Kinyen: Original FollowMe 1.1.1a, later maintained to v1.8.
  In the inherited source header Kinyen was misspelled "Kingen".
  The original ReadMe and Kinyen's 2005 WoWInterface forum post
  confirm the original author spelling.
  https://www.wowinterface.com/downloads/info4369-FollowMe.html
  https://www.wowinterface.com/forums/showthread.php?t=2507

  No other original addon by Kinyen was listed on his author page.
  Other addons by Lyriane were not independently verified.
