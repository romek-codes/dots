{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod,RETURN, exec, uwsm app -- ${pkgs.kitty}/bin/kitty" # Kitty (Terminal)
      "$mod,E, exec,  uwsm app -- ${pkgs.xfce.thunar}/bin/thunar" # Thunar (File explorer)
      "$ctrlMod,L, exec,  uwsm app -- ${pkgs.hyprlock}/bin/hyprlock" # Lock
      "$mod,X, exec, powermenu" # Powermenu
      "$mod,P, exec, app-menu" # Launcher

      "$mod,TAB,exec,${pkgs.rofi-wayland} -modes run,window -show window"
      "$mod,B, exec, bitwarden" # Rofi-rbw (Bitwarden)
      "$mod,C,exec,rofi -show calc -modi calc -no-show-match -no-sort"
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

      "$shiftMod,h,movewindow,l"
      "$shiftMod,j,movewindow,d"
      "$shiftMod,k,movewindow,u"
      "$shiftMod,l,movewindow,r"

      "$mod,PRINT, exec, screenshot region" # Screenshot region
      ",PRINT, exec, screenshot monitor" # Screenshot monitor
      "$shiftMod,PRINT, exec, screenshot window" # Screenshot window
      "ALT,PRINT, exec, screenshot region swappy" # Screenshot region then edit
      "$mod,A, exec,screenshot region swappy" # Screenshot region then edit

      "$shiftMod,T, exec, hyprpanel-toggle" # Toggle hyprpanel
      "$mod,V,exec,rofi-cliphist" # Clipboard history with rofi
      "$shiftMod,E, exec, rofimoji -f geometric_shapes geometric_shapes_extended nerd_font emojis" # Nerdfont and emoji picker with rofi
      "$mod,F2, exec, blue-light-filter" # Toggle blue light
      "$mod,TAB, exec, rofi -modes run,window -show window" # Search open windows

    ] ++ (builtins.concatLists (builtins.genList (i:
      let ws = i + 1;
      in [
        "$mod,code:1${toString i}, split-workspace, ${toString ws}"
        "$mod SHIFT,code:1${toString i}, split-movetoworkspace, ${toString ws}"
      ]) 10));

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse left click)
      "$mod,mouse:273, resizewindow" # Resize Window (mouse right click)
    ];

    bindl = [
      ",XF86AudioMute, exec, sound-toggle" # Toggle Mute
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
      ",switch:Lid Switch, exec, uwsm app -- ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
    ];

    bindr = [
      "SUPER, SUPER_L,exec, command-palette" # Command Palette
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      ",XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
      ",XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
    ];

  };
}
