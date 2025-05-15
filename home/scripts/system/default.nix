# - ## System
#- 
#- Usefull quick scripts
#-
#- - `menu` - Open rofi with drun mode. (rofi)
#- - `powermenu` - Open power dropdown menu. (rofi)
#- - `quickmenu` - Open a dropdown menu with shortcuts and scripts. (rofi)
#- - `lock` - Lock the screen. (hyprlock)
{ pkgs, ... }:

let
  # TODO: Remove the if checks, and watch if rofi opens multiple times when using it over a longer time period.
  menu = pkgs.writeShellScriptBin "menu"
    # bash
    ''
      rofi -display-drun "Apps" -show-icons -show drun &
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

  quickmenu = pkgs.writeShellScriptBin "quickmenu"
    # bash
    ''
      options=(
        " Nixy"
        "󰖔 Night-shift"
        "󰈊 Hyprpicker"
        "󰅶 Caffeine"
        "󰖂 Toggle VPN"
      )

      selected=$(printf '%s\n' "''${options[@]}" | rofi -i -p "Quickmenu" -dmenu)
      selected=''${selected:2}

      case $selected in
        "Caffeine")
          caffeine
          ;;
        "Night-shift")
          night-shift
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
      esac
    '';

  lock = pkgs.writeShellScriptBin "lock"
    # bash
    ''
      ${pkgs.hyprlock}/bin/hyprlock
    '';

in { home.packages = [ menu bitwarden powermenu lock quickmenu ]; }
