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
      selected=$(rofi -i -p "Command Palette | " -dmenu < <(
          printf " Nixy\0meta\x1fnixy nix package manager\n"
          printf "󰌆 Bitwarden (SUPER + B)\0meta\x1fbw password manager passwords\n"
          printf "󰀻 Search apps (SUPER + P)\0meta\x1fapp applications program software launcher\n"
          printf "󰖔 Toggle blue light filter (SUPER + F2)\0meta\x1fblf night mode eye strain redshift\n"
          printf "󰈊 Color picker\0meta\x1fcp pick color hex rgb\n"
          printf "󰱼 Search files\0meta\x1fsf find file browse directory\n"
          printf "󰱼 Search files recursively\0meta\x1fsfr find recursive deep file search\n"
          printf "󱂬 Search open windows (SUPER + TAB)\0meta\x1fsow window switcher alt-tab\n"
          printf "󰹑 Screenshot (SUPER + A / ALT + PRINTSCREEN)\0meta\x1fss screen capture print\n"
          printf "󰅶 Toggle suspend & screenlock\0meta\x1ftss sleep lock screen\n"
          printf "󰖂 Toggle VPN\0meta\x1ftvpn vpn network security\n"
          printf "󰐥 Powermenu (SUPER + X)\0meta\x1fpm power shutdown reboot logout\n"
          printf "󰱰 Nerdfont/Emoji picker (SUPER + SHIFT + E)\0meta\x1fnep emoji icon symbol\n"
          printf " Clipboard history (SUPER + V)\0meta\x1fch copy paste clipboard\n"
          printf " Calculator (SUPER + C)\0meta\x1fcalc math compute formula\n"
          printf " File explorer (SUPER + E)\0meta\x1ffe files browse folder directory\n"
          printf " Lock screen (CTRL + SUPER + L)\0meta\x1fls lock security\n"
          printf "󰌌 Change keyboard layout (SUPER + SPACE)\0meta\x1fckl keyboard input language\n"
          printf "󰕾 Sound & Media controls\0meta\x1fsmc audio volume media playback\n"
          printf " Hyprland controls\0meta\x1fhypr hyprland wm\n"
          printf " Open terminal (SUPER + ENTER)\0meta\x1fterm kitty wm\n"
      ))

      # If no selection was made (user pressed Escape), exit gracefully
      [ -z "$selected" ] && exit 0

      # Extract just the displayed text without the icon (if there is one)
      if [[ "$selected" =~ ^[[:space:]]*[^[:space:]] ]]; then
        selected=''${selected:2}
      fi

      command_found=0

      if [[ "$selected" == *"Toggle suspend & screenlock"* ]]; then
        suspend-and-screen-lock
        command_found=1
      elif [[ "$selected" == *"Open terminal"* ]]; then
        uwsm app -- ${pkgs.kitty}/bin/kitty
        command_found=1
      elif [[ "$selected" == *"Hyprland controls"* ]]; then
        hyprland-controls
        command_found=1
      elif [[ "$selected" == *"Search apps"* ]]; then
        app-menu
        command_found=1
      elif [[ "$selected" == *"Search files recursively"* ]]; then
        rofi -modi recursivebrowser -filebrowser-command 'thunar' -show recursivebrowser
        command_found=1
      elif [[ "$selected" == *"Search files"* && "$selected" != *"recursively"* ]]; then
        rofi -modi filebrowser -filebrowser-command 'thunar' -show filebrowser 
        command_found=1
      elif [[ "$selected" == *"Search open windows"* ]]; then
        rofi -modes run,window -show window
        command_found=1
      elif [[ "$selected" == *"Toggle blue light filter"* ]]; then
        blue-light-filter
        command_found=1
      elif [[ "$selected" == *"Nerdfont"* || "$selected" == *"Emoji picker"* ]]; then
        rofimoji -f geometric_shapes geometric_shapes_extended nerd_font emojis
        command_found=1
      elif [[ "$selected" == *"Nixy"* ]]; then
        nixy
        command_found=1
      elif [[ "$selected" == *"Color picker"* ]]; then
        sleep 0.2 && hyprpicker -a
        command_found=1
      elif [[ "$selected" == *"Toggle VPN"* ]]; then
        openvpn-toggle
        command_found=1
      elif [[ "$selected" == *"Powermenu"* ]]; then
        powermenu
        command_found=1
      elif [[ "$selected" == *"Bitwarden"* ]]; then
        rofi-rbw
        command_found=1
      elif [[ "$selected" == *"Screenshot"* ]]; then
        sleep 0.2 && screenshot region swappy
        command_found=1
      elif [[ "$selected" == *"Clipboard history"* ]]; then
        rofi-cliphist
        command_found=1
      elif [[ "$selected" == *"Calculator"* ]]; then
        rofi -show calc -modi calc -no-show-match -no-sort
        command_found=1
      elif [[ "$selected" == *"File explorer"* ]]; then
        uwsm app -- ${pkgs.xfce.thunar}/bin/thunar
        command_found=1
      elif [[ "$selected" == *"Lock screen"* ]]; then
        uwsm app -- ${pkgs.hyprlock}/bin/hyprlock
        command_found=1
      elif [[ "$selected" == *"Change keyboard layout"* ]]; then
        change-keyboard-layout
        command_found=1
      elif [[ "$selected" == *"Sound & Media controls"* ]]; then
        sound-and-media-controls
        command_found=1
      fi

      # Show notification if no command was found
      if [ $command_found -eq 0 ]; then
        notify-send "Command Palette" "No matching command found for: $selected" -i dialog-error
      fi
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
