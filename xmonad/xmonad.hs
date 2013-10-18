import XMonad
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)

import XMonad.Operations

import System.IO
import System.Exit

import XMonad.Util.Run

import XMonad.Actions.CycleWS

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier

import Data.Ratio ((%))

import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- Layout config.
myLayoutHook = smartBorders $ layoutHints $ avoidStruts $ tiled ||| Mirror tiled ||| Full ||| simpleFloat
    where
        tiled = ResizableTall 1 (2/100) (1/2) []

myBitmapsDir = "/home/allie/config/dzen2/icons/xbm"

colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"
colorBlack          = "#000000"
colorRed            = "red"

colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#FD971F"

tallIcon        = "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
mirrorTallIcon  = "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
fullIcon        = "^i(" ++ myBitmapsDir ++ "/full.xbm)"

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP {
        ppCurrent           = dzenColor colorOrange colorDarkGray . wrap "[" "]",
        ppVisible           = wrap "(" ")",
        ppUrgent            = dzenColor colorRed colorYellow,
        ppLayout = dzenColor "#ebac54" "#1B1D1E" .
            (\x -> case x of
                "Hinted ResizableTall"          -> tallIcon
                "Hinted Mirror ResizableTall"   -> mirrorTallIcon
                "Hinted Full"                   -> fullIcon
                "Hinted Simple Float"           -> "~"
                _                       -> x
            ),
        ppTitle = (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape,
        ppOutput = hPutStrLn h
    }

xftFont  = "xft: inconsolata-14"
barXFont = "inconsolata:size=12"

mXPConfig :: XPConfig
mXPConfig = defaultXPConfig {
    font = barXFont,
    bgColor = colorDarkGray,
    bgHLight = colorBlack,
    fgHLight = colorBlue,
    promptBorderWidth = 0,
    height = 14,
    historyFilter = deleteConsecutive
}

largeXPConfig :: XPConfig
largeXPConfig = mXPConfig {
    font    = xftFont,
    height  = 22
}

myTerminal      =   "lilyterm -e fish"
myFiler         =   "nautilus"
myBrowser       =   "luakit"
myScreenshooter =   "scrot -e 'mv $f ~/screenshots/'"
myLocker        =   "slock"

myXmonadBar = "dzen2 -fn 'Monospace:pixelsize=11' -x '0' -y '0' -h '14' -w '960' -ta 'l' -bg '#1B1D1E' -fg '#FFFFFF'"
myStatusBar = "conky -c /home/allie/config/dzen2/conky_dzen | dzen2 -fn 'Monospace:pixelsize=11' -x '960' -y '0' -w '960' -h '14' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' "

disableLeftScreen = "xrandr --output HDMI1 --off"
setupDisplays=  "xrandr --output HDMI1 --left-of HDMI2"
myRestart = "/home/allie/.cabal/bin/xmonad --recompile && killall conky dzen2 && /home/allie/.cabal/bin/xmonad --restart"
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $ [
    ((modMask,                  xK_p        ), runOrRaisePrompt largeXPConfig),
    ((modMask,                  xK_u        ), runOrRaisePrompt mXPConfig),
    ((modMask .|. shiftMask,    xK_Return   ), spawn $ XMonad.terminal conf),
    ((modMask .|. shiftMask,    xK_c        ), kill),
    ((modMask .|. shiftMask,    xK_l        ), spawn myLocker),
    ((0,                        xK_Print    ), spawn myScreenshooter),
    ((modMask,                  xK_o        ), spawn myBrowser),
    ((modMask,                  xK_f        ), spawn myFiler),
    ((modMask,                  xK_m        ), spawn setupDisplays),
    ((modMask .|. shiftMask,    xK_m        ), spawn disableLeftScreen),
    ((modMask,                  xK_space    ), sendMessage NextLayout),
    ((modMask .|. shiftMask,    xK_space    ), setLayout $ XMonad.layoutHook conf),
    ((modMask .|. shiftMask,    xK_b        ), sendMessage ToggleStruts),
    ((modMask,                  xK_n        ), refresh),
    ((modMask,                  xK_Tab      ), windows W.focusDown),
    ((modMask,                  xK_j        ), windows W.focusDown),
    ((modMask,                  xK_k        ), windows W.focusUp),
    ((modMask .|. shiftMask,    xK_j        ), windows W.swapDown),
    ((modMask .|. shiftMask,    xK_k        ), windows W.swapUp),
    ((modMask,                  xK_Return   ), windows W.swapMaster),
    ((modMask,                  xK_t        ), withFocused $ windows . W.sink),
    ((modMask,                  xK_h        ), sendMessage Shrink),
    ((modMask,                  xK_l        ), sendMessage Expand),
    ((modMask,                  xK_comma    ), sendMessage (IncMasterN 1)),
    ((modMask,                  xK_period   ), sendMessage (IncMasterN (-1))),
    ((modMask .|. controlMask,  xK_Right    ), nextWS),
    ((modMask .|. shiftMask,    xK_Right    ), shiftToNext),
    ((modMask .|. controlMask,  xK_Left     ), prevWS),
    ((modMask .|. shiftMask,    xK_Left     ), shiftToPrev),
    ((modMask .|. shiftMask,    xK_q        ), io (exitWith ExitSuccess)),
    ((modMask,                  xK_q        ), spawn myRestart)] ++
    [((m .|. modMask, k), windows $ f i) |
        (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
        (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]] ++

    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f)) |
        (key, sc) <- zip [ xK_w, xK_e, xK_r] [0..],
        (f,m) <- [(W.view, 0), (W.shift, shiftMask)]]

main = do
    dzenLeftBar <-spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ defaultConfig {
        terminal = myTerminal,
        keys = myKeys,
        layoutHook = myLayoutHook,
        logHook = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd,
        normalBorderColor = colorNormalBorder,
        focusedBorderColor = colorFocusedBorder,
        focusFollowsMouse = True
    }

