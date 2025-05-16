# - ## System
#- 
#- Usefull quick scripts
#-
#- - `menu` - Open rofi with drun mode. (rofi)
#- - `powermenu` - Open power dropdown menu. (rofi)
#- - `command-palette` - Open a dropdown menu with shortcuts and scripts. (rofi)
#- - `lock` - Lock the screen. (hyprlock)
{ pkgs, ... }:

let
  appMenu = pkgs.writeShellScriptBin "app-menu"
    # bash
    ''
      rofi -display-drun "Apps" -show-icons -show drun -sort -auto-select
    '';

  bitwarden = pkgs.writeShellScriptBin "bitwarden"
    # bash
    ''
      rofi-rbw 
    '';

  powermenu = pkgs.writeShellScriptBin "powermenu"
    # bash
    ''
      options=(
        "󰌾 Lock"
        "󰍃 Logout"
        " Suspend"
        "󰑐 Reboot"
        "󰿅 Shutdown"
      )

      selected=$(printf '%s\n' "''${options[@]}" | rofi -i -p "Powermenu" -dmenu)
      selected=''${selected:2}

      case $selected in
        "Lock")
          ${pkgs.hyprlock}/bin/hyprlock
          ;;
        "Logout")
          hyprctl dispatch exit
          ;;
        "Suspend")
          systemctl suspend
          ;;
        "Reboot")
          systemctl reboot
          ;;
        "Shutdown")
          systemctl poweroff
          ;;
      esac
    '';

  commandPalette = pkgs.writeShellScriptBin "command-palette"
    # bash
    ''
      options=(
        " Nixy"
        "󰌆 Bitwarden (SUPER + B)"
        "󰀻 Search apps (SUPER + P)"
        "󰖔 Night-shift (SUPER + F2)"
        "󰈊 Hyprpicker"
        "󰱼 Search files"
        "󰱼 Search files recursively"
        "󱂬 Search open windows (SUPER + TAB)"
        "󰹑 Screenshot (SUPER + A / ALT + PRINTSCREEN)"
        "󰅶 Caffeine"
        "󰖂 Toggle VPN"
        "󰐥 Powermenu (SUPER + X)"
        "󰱰 Nerdfont/Emoji picker (SUPER + SHIFT + E)"
        " Clipboard history (SUPER + V)"
        " Calculator (SUPER + C)"
        " File explorer (SUPER + E)"
        " Lock screen (CTRL + SUPER + L)"Change keyboard layout
        "󰌌 Change keyboard layout (SUPER + SPACE)"
        "󰕾 Sound & Media controls"
        " Hyprland controls"
      )

      selected=$(printf '%s\n' "''${options[@]}" | rofi -i  -p "Command Palette | " -dmenu -auto-select)

      selected=''${selected:2}

      case $selected in
        "Hyprland controls")
          hyprland-controls
          ;;
        "Search apps (SUPER + P)")
          app-menu
          ;;
        "Search files recursively")
          rofi -modi recursivebrowser -filebrowser-command 'uwsm app -- ${pkgs.xfce.thunar}/bin/thunar' -show recursivebrowser
          ;;
        "Search files")
          rofi -modi filebrowser -filebrowser-command 'uwsm app -- ${pkgs.xfce.thunar}/bin/thunar' -show filebrowser 
          ;;
        "Search open windows (SUPER + TAB)")
          rofi -modes run,window -show window
          ;;
        "Night-shift (SUPER + F2)")
          night-shift
          ;;
        "Nerdfont/Emoji picker (SUPER + SHIFT + E)")
          rofimoji -f geometric_shapes geometric_shapes_extended nerd_font emojis
          ;;
        "Nixy")
            kitty zsh -c "nixy; echo; echo 'Press return to exit...'; read"
          ;;
        "Hyprpicker")
          sleep 0.2 && ${pkgs.hyprpicker}/bin/hyprpicker -a
          ;;
        "Toggle VPN")
          openvpn-toggle
          ;;
        "Powermenu (SUPER + X)")
          powermenu
          ;;
        "Bitwarden (SUPER + B)")
          rofi-rbw
          ;;
        "Screenshot (SUPER + A / ALT + PRINTSCREEN)")
            screenshot region swappy
          ;;
        "Emoji picker")
          rofimoji
          ;;
        "Clipboard history (SUPER + V)")
          rofi-copyq
          ;;
        "Calculator (SUPER + C)")
            rofi -show calc -modi calc -no-show-match -no-sort
          ;;
        "File explorer (SUPER + E)")
            uwsm app -- ${pkgs.xfce.thunar}/bin/thunar
          ;;
        "Lock screen (CTRL + SUPER + L)")
            uwsm app -- ${pkgs.hyprlock}/bin/hyprlock
          ;;
        "Change keyboard layout (SUPER + SPACE)")
            change-keyboard-layout
          ;;
        "Sound & Media controls")
            sound-and-media-controls
          ;;
      esac
    '';

  hyprlandControls = pkgs.writeShellScriptBin "hyprland-controls"
    # bash
    ''
      options=(
        "Toggle fullscreen (SUPER + F)"
        "Toggle floating (SUPER + T)"
        "Toggle hyprpanel / bar (SUPER + SHIFT + T)"
        ""
      )

      selected=$(printf '%s\n' "''${options[@]}" | rofi -i -p "Quickmenu" -dmenu -auto-select)

      case $selected in
        "Toggle hyprpanel / bar")
          hyprpanel-toggle
          ;;
        "Toggle fullscreen")
          hyprctl dispatch fullscreen
          ;;
        "Toggle floating")
          hyprctl dispatch togglefloating
          ;;
      esac
    '';

  soundAndMediaControls = pkgs.writeShellScriptBin "sound-and-media-controls"
    # bash
    ''
      options=(
        "Play/Pause"
        "Next"
        "Previous"
        "Mute"
        "Set volume"
        "Set brightness"
      )

      selected=$(printf '%s\n' "''${options[@]}" | rofi -i -p "Quickmenu" -dmenu -auto-select)

      case $selected in
        "Play/Pause")
          ${pkgs.playerctl}/bin/playerctl play-pause
          ;;
        "Next")
          ${pkgs.playerctl}/bin/playerctl next
          ;;
        "Previous")
          ${pkgs.playerctl}/bin/playerctl previous
          ;;
        "Mute")
          sound-toggle
          ;;
        "Set volume")
          # Get volume value from user using rofi
          volume=$(rofi -dmenu -p "Enter volume (0-100)" -l 0)
          # Check if input is valid
          if [[ "$volume" =~ ^[0-9]+$ ]] && [ "$volume" -ge 0 ] && [ "$volume" -le 100 ]; then
            sound-set "$volume"
          else
            notify-send "Invalid volume" "Please enter a number between 0 and 100"
          fi
          ;;
        "Set brightness")
          # Get brightness value from user using rofi
          brightness=$(rofi -dmenu -p "Enter brightness (0-100)" -l 0)
          # Check if input is valid
          if [[ "$brightness" =~ ^[0-9]+$ ]] && [ "$brightness" -ge 0 ] && [ "$brightness" -le 100 ]; then
            brightness-set "$brightness"
          else
            notify-send "Invalid brightness" "Please enter a number between 0 and 100"
          fi
          ;;
      esac
    '';

  changeKeyboardLayout = pkgs.writeShellScriptBin "change-keyboard-layout"
    # bash
    ''
      switch=$(hyprctl devices -j | jq -r '.keyboards[] | .active_keymap' | uniq -c | [ $(wc -l) -eq 1 ] && echo "next" || echo "0"); for device in $(hyprctl devices -j | jq -r '.keyboards[] | .name'); do hyprctl switchxkblayout $device $switch; done; activeKeymap=$(hyprctl devices -j | jq -r '.keyboards[0] | .active_keymap'); if [ $switch == "0" ]; then resetStr="(reset)"; else resetStr=""; fi; hyprctl notify -1 1500 0 "$activeKeymap $resetStr"
    '';

  lock = pkgs.writeShellScriptBin "lock"
    # bash
    ''
      ${pkgs.hyprlock}/bin/hyprlock
    '';

in {
  home.packages = [
    appMenu
    bitwarden
    powermenu
    lock
    commandPalette
    hyprlandControls
    soundAndMediaControls
    changeKeyboardLayout
  ];
}
