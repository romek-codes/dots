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

  home.packages = with pkgs; [
    rofimoji
    rofi-rbw-wayland
    # TODO: get this horrible thing working
    # (pkgs.rustPlatform.buildRustPackage rec {
    #     pname = "rofi-nerdy";
    #     version = "0.1.0";
    #
    #     src = fetchFromGitHub {
    #       owner = "Rolv-Apneseth";
    #       repo = "rofi-nerdy";
    #       rev = "7cd38a9a91a518db9884878c158fc4fafc584c65";
    #       sha256 = "sha256-Le8oI6R7R50AysoEvw+u6i0Onust3TIFI+f7nxZ34XY=";
    #     };
    #
    #     cargoPatches = [
    #       ./add-Cargo.lock.patch
    #     ];
    #
    #     cargoHash = lib.fakeHash;
    #
    #     postPatch = ''
    #       ln -s ${./add-Cargo.lock.patch} Cargo.lock
    #     '';
    #
    #     buildPhase = ''
    #       cargo build --release --lib
    #     '';
    #
    #     dontInstall = true;
    #
    #     installPhase = ''
    #       mkdir -p $out/lib/rofi
    #       cp target/release/librofi_nerdy.so $out/lib/rofi/nerdy.so
    #     '';
    #
    #     buildInputs = [ pkgs.rofi-wayland ];
    #
    #     # If you're using the bleeding edge version of rofi, uncomment this line:
    #     RUSTFLAGS = "--cfg rofi_next";
    #
    #     meta = {
    #       description = "Nerdfont symbol picker plugin for rofi";
    #       homepage = "https://github.com/Rolv-Apneseth/rofi-nerdy";
    #       license = lib.licenses.mit;
    #       maintainers = [ ];
    #     };
    #   })
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [ rofi-calc ]; # rofi-emoji
    # TODO: Get rounding / border-radius working for rofi
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in { window = { border-radius = toString rounding + "px"; }; };
  };
}
