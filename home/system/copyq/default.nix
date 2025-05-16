{ pkgs, ... }:
let
  rofi-cliphist = pkgs.writeShellScriptBin "rofi-cliphist"
    # bash
    ''
      cliphist list | rofi -dmenu | cliphist decode | wl-copy
    '';
in {

  home.packages = with pkgs; [ cliphist rofi-cliphist ];

  # services.copyq.enable = true;

  wayland.windowManager.hyprland.settings.exec-once = [
    "wl-paste --type text --watch cliphist store # Stores only text data"
    "wl-paste --type image --watch cliphist store # Stores only image data"
  ];

  # systemd.user.services.copyq = {
  #   Unit = {
  #     Description = "CopyQ, a clipboard manager";
  #     Documentation = [ "man:copyq(5)" ];
  #     Wants = [ "graphical-session.target" ];
  #     Requires = [ "graphical-session.target" ];
  #     After = [ "graphical-session.target" ];
  #   };
  #
  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.copyq}/bin/copyq";
  #     KillMode = "process";
  #     KillSignal = "SIGINT";
  #   };
  #
  #   Install = { WantedBy = [ "graphical-session.target" ]; };
  # };
  # xdg.configFile."copyq/copyq.conf".source = ./copyq.conf;
}
