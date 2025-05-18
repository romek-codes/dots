# - ## Nixy
#- 
#- Nixy is a simple script that I use to manage my NixOS system. It's a simple script that provides a menu to rebuild, upgrade, update, collect garbage, clean boot menu, etc. 
#-
#- - `nixy` - UI wizard to manage the system.
#- - `nixy rebuild` - Rebuild the system.
#- - `nixy ...` - ... see the script for more commands.
{ pkgs, config, inputs, ... }:
let

  configDirectory = config.var.configDirectory;
  hostname = config.var.hostname;

  nixy = pkgs.writeShellScriptBin "nixy"
    # bash
    ''
      # Define prefix and suffix for commands
      # prefix to open command in kitty, inside a tmux session, for yanking with /, also send return on open to end previous command, doesnt work sometimes though.
      prefix="kitty zsh -c 'if tmux has-session -t nixy 2>/dev/null; then tmux attach -t nixy; else tmux new-session -s nixy \" echo -ne \n |"
      # suffix to wait for enter input
      suffix="; echo \\\"Press return to exit...\\\"; read\"; fi'"

      function run_command_with_prefix_and_suffix() {
        local cmd="$@"
        eval "$prefix$cmd$suffix"
      }

      function run_command() {
        local cmd="$1"
        eval "$cmd"
      }


      function ui(){
        DEFAULT_ICON="󰘳"

        # "icon;name;command"[]
        options=(
          "󰑓;Rebuild;nixy rebuild"
          "󰦗;Upgrade;nixy upgrade"
          "󰚰;Update;nixy update"
          ";Collect Garbage;nixy gc"
          "󰍜;Clean Boot Menu;nixy cb"
          ";List generations;nixy listgen"
        )

        # Apply default icons if empty:
        for i in "''${!options[@]}"; do
          options[i]=$(echo "''${options[i]}" | sed 's/^;/'$DEFAULT_ICON';/')
        done

        # Format options for rofi menu
        menu_items=""
        for option in "''${options[@]}"; do
          icon=$(echo "$option" | cut -d';' -f1)
          name=$(echo "$option" | cut -d';' -f2)
          menu_items+="$icon $name\n"
        done

        # Display menu with rofi
        selected=$(echo -e "''${menu_items}" | rofi -i -p "Nixy" -dmenu)
        [[ -z $selected ]] && exit 0

        # Find the selected command
        for option in "''${options[@]}"; do
          icon=$(echo "$option" | cut -d';' -f1)
          name=$(echo "$option" | cut -d';' -f2)
          command=$(echo "$option" | cut -d';' -f3)

          if [[ "$selected" == "$icon $name" ]]; then
            run_command_with_prefix_and_suffix "$command" # this causes second terminal to be opened
            exit $?
          fi
        done
      }

      [[ $1 == "" ]] && ui
      if [[ $1 == "rebuild" ]];then
        cmd="cd ${configDirectory} && git add . && sudo nixos-rebuild switch --flake ${configDirectory}#${hostname}"
        run_command "$cmd"
      elif [[ $1 == "upgrade" ]];then
        cmd="sudo nixos-rebuild switch --upgrade --flake '${configDirectory}#${hostname}'"
        run_command "$cmd"
      elif [[ $1 == "update" ]];then
        cmd="cd ${configDirectory} && nix flake update"
        run_command "$cmd"
      elif [[ $1 == "gc" ]];then
        cmd="cd ${configDirectory} && sudo nix-collect-garbage -d"
        run_command "$cmd"
      elif [[ $1 == "cb" ]];then
        cmd="sudo /run/current-system/bin/switch-to-configuration boot"
        run_command "$cmd"
      elif [[ $1 == "listgen" ]];then
        cmd="sudo nix-env -p /nix/var/nix/profiles/system --list-generations"
        run_command "$cmd"
      else
        echo "Unknown argument"
      fi
    '';

in { home.packages = [ nixy ]; }
