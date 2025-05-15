# Spicetify is a spotify client customizer
{ pkgs, config, lib, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  accent = "${config.lib.stylix.colors.base0D}";
  background = "${config.lib.stylix.colors.base00}";
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  stylix.targets.spicetify.enable = false;

  programs.spicetify = {
    enable = true;
    theme = lib.mkForce spicePkgs.themes.dribbblish;
    alwaysEnableDevTools = true;

    colorScheme = "custom";
    customColorScheme = {
      button = accent;
      button-active = accent;
      tab-active = accent;
      player = background;
      main = background;
      sidebar = background;
    };

    enabledExtensions = with spicePkgs.extensions; [
      # playlistIcons
      # simpleBeautifulLyrics
      # hidePodcasts
      adblock
      # fullAppDisplay
      {
        src = "${
            pkgs.fetchFromGitHub {
              owner = "romek-codes";
              repo = "huh-spicetify-extensions";
              rev = "4089684621f15b458102decc600b855903df2cab";
              hash = "sha256-gtwhb8HYN/Xgv2DrYJ7JZYdE+v7L0x4DgvhIYeQLirE=";
            }
          }/fullAppDisplayModified";
        name = "fullAppDisplayMod.js";
      }
      keyboardShortcut
    ];

    enabledCustomApps = with spicePkgs.apps;
      [
        # lyricsPlus
        {
          src = "${
              pkgs.fetchFromGitHub {
                owner = "romek-codes";
                repo = "cli";
                rev = "5915709702ca8ff17dbaa363c54081409f352c01";
                hash = "sha256-QLdmTC3L0KENja8y18qLLL1iJOWa9+U9zMAYbBwRBoA=";
              }
            }/CustomApps/lyrics-plus";
          name = "lyrics-plus";
        }
      ];
  };
}
