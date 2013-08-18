import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import System.IO

main = do 
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig { 
        manageHook = manageDocks,
        layoutHook = avoidStruts $ layoutHook defaultConfig,
        logHook = dynamicLogWithPP xmobarPP { 
            ppOutput = hPutStrLn xmproc,
            ppTitle = xmobarColor "brown" "" 
        },
        terminal = "xfce4-terminal" ,
        focusFollowsMouse = False
    }

