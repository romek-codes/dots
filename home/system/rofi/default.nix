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

  home.packages = with pkgs; [ rofimoji rofi-rbw-wayland rofi-calc ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    # TODO: Get rounding / border-radius working for rofi
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in { window = { border-radius = toString rounding + "px"; }; };
  };
}
