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
            prefix="kitty zsh -c '"
            suffix="; echo \"Press return to exit...\"; read'"

            function exec() {
              local cmd="$@"
              eval "$prefix$cmd$suffix"
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
                ";List generation;nixy listgen"
                "󰌌;Hyprland Keybindings;nvim ${configDirectory}/docs/KEYBINDINGS-HYPRLAND.md"
                "󰋩;Wallpapers;zen https://github.com/anotherhadi/nixy-wallpapers"
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
                  exec "$command" # this causes second terminal to be opened
                  exit $?
                fi
              done
            }

            function run_command() {
              local cmd="$1"
              eval "$prefix$cmd$suffix"
            }

            [[ $1 == "" ]] && ui
            #
            if [[ $1 == "rebuild" ]];then
              cmd="cd ${configDirectory} && git add . && sudo nixos-rebuild switch --flake ${configDirectory}#${hostname}"
              # run_command "$cmd"
            elif [[ $1 == "upgrade" ]];then
              cmd="sudo nixos-rebuild switch --upgrade --flake '${configDirectory}#${hostname}'"
              # run_command "$cmd"
            elif [[ $1 == "update" ]];then
              cmd="cd ${configDirectory} && nix flake update"
              # run_command "$cmd"
            elif [[ $1 == "gc" ]];then
              cmd="cd ${configDirectory} && sudo nix-collect-garbage -d"
              # run_command "$cmd"
            elif [[ $1 == "cb" ]];then
              cmd="sudo /run/current-system/bin/switch-to-configuration boot"
              # run_command "$cmd"
            elif [[ $1 == "listgen" ]];then
              cmd="sudo nix-env -p /nix/var/nix/profiles/system --list-generations"
              # run_command "$cmd"
            else
              echo "Unknown argument"
            fi
    '';

in { home.packages = [ nixy ]; }
