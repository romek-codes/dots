{ config, pkgs, lib, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";
  foreground = "#${config.lib.stylix.colors.base05}";
  font = config.stylix.fonts.serif.name;
  rounding = config.theme.rounding;
  font-size = config.stylix.fonts.sizes.popups;
in {

  home.packages = with pkgs; [ rofimoji rofi-rbw-wayland ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [ rofi-calc ]; # rofi-emoji
    # TODO: Get rounding / border-radius working for rofi
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in { "window" = { border-radius = toString rounding + "px"; }; };
  };

  # https://github.com/fdw/rofi-rbw/issues/107
  xdg.configFile."rofi-rbw.rc".text = ''
    keybindings Alt+Meta+1:type:username:tab:password,Alt+Meta+2:type:username,Alt+Meta+3:type:password,Alt+Meta+4:type:totp,Alt+Meta+c:copy:password,Alt+Meta+u:copy:username,Alt+Meta+t:copy:totp,Alt+Meta+m::menu
  '';

}
