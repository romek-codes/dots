{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod,RETURN, exec, uwsm app -- ${pkgs.kitty}/bin/kitty" # Kitty (Terminal)
      "$mod,E, exec,  uwsm app -- ${pkgs.xfce.thunar}/bin/thunar" # Thunar (File explorer)
      "$ctrlMod,L, exec,  uwsm app -- ${pkgs.hyprlock}/bin/hyprlock" # Lock
      "$mod,X, exec, powermenu" # Powermenu
      "$mod,P, exec, menu" # Launcher
      "$ctrlMod,K, exec, bitwarden" # Rofi-rbw (Bitwarden)
      "$mod,C, exec, quickmenu" # Quickmenu
      "$mod,Z,exec,rofi -show calc -modi calc -no-show-match -no-sort"
      ''
        $mod,SPACE,exec,switch=$(hyprctl devices -j | jq -r '.keyboards[] | .active_keymap' | uniq -c | [ $(wc -l) -eq 1 ] && echo "next" || echo "0"); for device in $(hyprctl devices -j | jq -r '.keyboards[] | .name'); do hyprctl switchxkblayout $device $switch; done; activeKeymap=$(hyprctl devices -j | jq -r '.keyboards[0] | .active_keymap'); if [ $switch == "0" ]; then resetStr="(reset)"; else resetStr=""; fi; hyprctl notify -1 1500 0 "$activeKeymap $resetStr"; # Change keyboard layout
      ''
      "$mod,Q, killactive," # Close window
      "$mod,T, togglefloating," # Toggle Floating
      "$mod,F, fullscreen" # Toggle Fullscreen
      "$mod,h, movefocus, l" # Move focus left
      "$mod,j, movefocus, d" # Move focus Down
      "$mod,k, movefocus, u" # Move focus Up
      "$mod,l, movefocus, r" # Move focus Right

      "$mod,PRINT, exec, screenshot region" # Screenshot region
      ",PRINT, exec, screenshot monitor" # Screenshot monitor
      "$shiftMod,PRINT, exec, screenshot window" # Screenshot window
      "ALT,PRINT, exec, screenshot region swappy" # Screenshot region then edit
      "$mod,A, exec,  uwsm app -- zen-beta" # # Screenshot region then edit

      "$shiftMod,T, exec, hyprpanel-toggle" # Toggle hyprpanel
      # TODO: Modify to use copyq instead of clipman
      "$shiftMod,C, exec, clipboard" # Clipboard picker with wofi
      "$shiftMod,E, exec, rofimoji" # Emoji picker with rofi
      "$mod,F2, exec, night-shift" # Toggle night shift
      "$mod,F3, exec, night-shift" # Toggle night shift
    ] ++ (builtins.concatLists (builtins.genList (i:
      let ws = i + 1;
      in [
        "$mod,code:1${toString i}, split-workspace, ${toString ws}"
        "$mod SHIFT,code:1${toString i}, split-movetoworkspace, ${toString ws}"
      ]) 9));

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioMute, exec, sound-toggle" # Toggle Mute
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
      ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      ",XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
      ",XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
    ];

  };
}
