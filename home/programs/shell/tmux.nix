# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{ lib, pkgs, config, ... }:
let
  background = "#${config.lib.stylix.colors.base02}";
  tmuxConf = lib.readFile ./tmux.conf;
  styleConf = ''
    set-window-option -g window-status-current-style "fg=${background},bg=#1f292e"
    set-window-option -g window-status-current-format "#[fg=#1f292e,bg=${background},nobold,noitalics,nounderscore]#[fg=#516d7b,bg=${background}] #I #[fg=#516d7b,bg=${background},bold] #W#{?window_zoomed_flag,*Z,} #[fg=${background},bg=#1f292e,nobold,noitalics,nounderscore]"
  '';
  fullTmuxConf = tmuxConf + styleConf;
in {

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    escapeTime = 0;
    terminal = "kitty";
    keyMode = "vi";
    clock24 = true;
    extraConfig = lib.mkAfter fullTmuxConf;

    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.tmux-which-key
    ];
  };

  # stylix better looking status bar
  home.sessionVariables = {
    TINTED_TMUX_OPTION_ACTIVE = "1";
    TINTED_TMUX_OPTION_STATUSBAR = "1";
  };
}
