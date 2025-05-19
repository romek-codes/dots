# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{ lib, pkgs, config, ... }:
let
  # plugins = pkgs.tmuxPlugins // pkgs.callPackage ./custom-plugins.nix { };
  background = "#${config.lib.stylix.colors.base02}";
  tmuxConf = lib.readFile ./tmux.conf;
  # TODO: How to override this ugly ahh yellow for active ?
  fullTmuxConf = tmuxConf + "setw -g window-status-current-style bg="
    + background;
in {

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    prefix = "C-s";
    escapeTime = 0;
    terminal = "kitty";
    keyMode = "vi";

    extraConfig = fullTmuxConf;

    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.tmux-which-key
      # tmuxPlugins.tokyo-night-tmux
    ];
  };

  # stylix better looking status bar
  home.sessionVariables = {
    BASE16_TMUX_OPTION_ACTIVE = 1;
    BASE16_TMUX_OPTION_STATUSBAR = 1;
  };
}
