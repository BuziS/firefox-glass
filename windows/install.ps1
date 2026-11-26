# Installs the Firefox Glass theme into your Firefox profile (Windows).
# Usage: right-click > Run with PowerShell, or double-click Install.bat. Optional: -ProfilePath "C:\...\xxxx.default-release"
param([string]$ProfilePath)
$ErrorActionPreference = 'Stop'
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = "$env:APPDATA\Mozilla\Firefox"
if ($ProfilePath) { $P = $ProfilePath } else {
  # The profile Firefox really opens is in the [Install...] section; fall back to the profile marked Default=1.
  $ini = Get-Content "$root\profiles.ini"; $rel = $null; $sec = ''; $path = $null
  foreach ($l in $ini) {
    if ($l -match '^\[(.+)\]') { $sec = $Matches[1]; $path = $null; continue }
    if ($sec -like 'Install*' -and $l -match '^Default=(.+)$') { $rel = $Matches[1]; break }
  }
  if (-not $rel) { foreach ($l in $ini) { if ($l -match '^\[') { $path = $null }; if ($l -match '^Path=(.+)$') { $path = $Matches[1] }; if ($l -eq 'Default=1' -and $path) { $rel = $path; break } } }
  $P = Join-Path $root ($rel -replace '/','\')
}
if (-not (Test-Path $P)) { throw "Firefox profile not found: $P" }
Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep 3
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
# An existing theme is not deleted: its chrome folder is moved aside as a backup, then the new theme is installed clean.
$chrome = Join-Path $P 'chrome'
if (Test-Path $chrome) { Rename-Item $chrome "chrome-backup-$stamp"; Write-Output "Old theme saved as chrome-backup-$stamp" }
New-Item -ItemType Directory -Force $chrome | Out-Null
if (Test-Path (Join-Path $P 'user.js')) { Copy-Item (Join-Path $P 'user.js') (Join-Path $P "user.js.bak-$stamp") }
Copy-Item (Join-Path $src 'chrome\*') $chrome -Recurse -Force
Copy-Item (Join-Path $src 'user.js') $P -Force
# Settings the look needs, written once into prefs.js (you can still change them later in Firefox).
$prefs = Join-Path $P 'prefs.js'
$t = if (Test-Path $prefs) { Copy-Item $prefs (Join-Path $P "prefs.js.bak-$stamp"); [IO.File]::ReadAllText($prefs) } else { '' }
function Set-Pref([string]$name, [string]$value) {
  $line = "user_pref(""$name"", $value);"
  $rx = 'user_pref\("' + [regex]::Escape($name) + '",[^\r\n]*\);'
  if ($script:t -match $rx) { $script:t = [regex]::Replace($script:t, $rx, { param($m) $line }) } else { $script:t = $script:t.TrimEnd() + "`n" + $line + "`n" }
}
# Bookmarks capsule: bookmarks bar shown on new tabs only
Set-Pref 'browser.toolbars.bookmarks.visibility' '"newtab"'
Set-Pref 'browser.newtabpage.activity-stream.topSitesRows' '2'
# New tab like the Mac: shortcuts only, no widgets/weather/stories
foreach ($w in 'clocks','crossword','lists','pictureOfTheDay','sportsWidget','weather') { Set-Pref "browser.newtabpage.activity-stream.widgets.$w.enabled" 'false' }
Set-Pref 'browser.newtabpage.activity-stream.showWeather' 'false'
Set-Pref 'browser.newtabpage.activity-stream.feeds.section.topstories' 'false'
Set-Pref 'browser.newtabpage.activity-stream.feeds.topsites' 'true'
Set-Pref 'browser.newtabpage.activity-stream.showSponsoredTopSites' 'false'
# Share button: add it to the toolbar (theme joins it with + into one capsule)
$layout = '{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"share-tab-button\",\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"customizableui-special-spring3\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[],\"dirtyAreaCache\":[\"nav-bar\",\"TabsToolbar\",\"vertical-tabs\",\"toolbar-menubar\",\"PersonalToolbar\",\"unified-extensions-area\"],\"currentVersion\":28,\"newElementCount\":3}'
if ($t -match 'browser\.uiCustomization\.state') {
  if ($t -notmatch 'share-tab-button') { $t = $t -replace '(\\"nav-bar\\":\[)', '$1\"share-tab-button\",' }
} else { Set-Pref 'browser.uiCustomization.state' ('"' + $layout + '"') }
[IO.File]::WriteAllText($prefs, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'Share button and bookmarks capsule set'
Write-Output "Installed into $P - you can open Firefox now."
