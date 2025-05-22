# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{ lib, pkgs, config, ... }:
let
  background-current = "#${config.lib.stylix.colors.base00}";
  background = "#${config.lib.stylix.colors.base04}";
  background-other = "#${config.lib.stylix.colors.base01}";
  foreground-current = "#${config.lib.stylix.colors.base06}";
  accent = "#${config.lib.stylix.colors.base08}";
  accent-second = "#${config.lib.stylix.colors.base0D}";
  tmuxConf = lib.readFile ./tmux.conf;
  # For overriding all the stylix styles.
  styleConf = ''
    # # default statusbar colors
    # set-option -g status-style "fg=${background},bg=${foreground-current}"
    #
    # # default window title colors
    # set-window-option -g window-status-style "fg=${background},bg=${foreground-current}"
    #
    # # active window title colors
    # set-window-option -g window-status-current-style "fg=${foreground-current},bg=${background-current}"
    #
    # # pane border
    # set-option -g pane-border-style "fg=${foreground-current}"
    # set-option -g pane-active-border-style "fg=${background}"
    #
    # # message text
    # set-option -g message-style "fg=${foreground-current},bg=${background-other}"
    #
    # # pane number display
    # set-option -g display-panes-active-colour "${background}"
    # set-option -g display-panes-colour "${foreground-current}"
    #
    # # clock
    # set-window-option -g clock-mode-colour "${accent-second}"
    #
    # # copy mode highlight
    # set-window-option -g mode-style "fg=${background},bg=${background-other}"
    #
    # # bell
    # set-window-option -g window-status-bell-style "fg=${background-current},bg=${accent}"
    #
    # # style for window titles with activity
    # set-window-option -g window-status-activity-style "fg=${foreground-current},bg=${foreground-current}"
    #
    # # style for command messages
    # set-option -g message-command-style "fg=${foreground-current},bg=${background-other}"
    #
    # # Optional active/inactive pane state
    # # BASE16_TMUX_OPTION_ACTIVE is a legacy variable
    # if-shell '[ "$TINTED_TMUX_OPTION_ACTIVE" = "1" ] || [ "$BASE16_TMUX_OPTION_ACTIVE" = "1" ]' {
    #   set-window-option -g window-active-style "fg=${foreground-current},bg=${background-current}"
    #   set-window-option -g window-style "fg=${foreground-current},bg=${foreground-current}"
    # }
    #
    # # Optional statusbar
    # # BASE16_TMUX_OPTION_STATUSBAR is a legacy variable
    # if-shell '[ "$TINTED_TMUX_OPTION_STATUSBAR" = "1" ] || [ "$BASE16_TMUX_OPTION_STATUSBAR" = "1" ]' {
    #   set-option -g status "on"
    #   set-option -g status-justify "left" 
    #   set-option -g status-left "#[fg=${foreground-current},bg=${background-other}}] #S #[fg=${background-other}},bg=${foreground-current},nobold,noitalics,nounderscore]"
    #   set-option -g status-left-length "80"
    #   set-option -g status-left-style none
    #   set-option -g status-right "#[fg=${background-other},bg=${foreground-current} nobold, nounderscore, noitalics]#[fg=${background},bg=${background-other}] %Y-%m-%d  %H:%M #[fg=${foreground-current},bg=${background-other},nobold,noitalics,nounderscore]#[fg=${foreground-current},bg=${foreground-current}] #h "
    #   set-option -g status-right-length "80"
    #   set-option -g status-right-style none
    #   set-window-option -g window-status-current-format "#[fg=${foreground-current},bg=${background-current},nobold,noitalics,nounderscore]#[fg=${background-other},bg=${foreground-current}] #I #[fg=${background-other},bg=${foreground-current},bold] #W#{?window_zoomed_flag,*Z,} #[fg=${foreground-current},bg=${foreground-current},nobold,noitalics,nounderscore]"
    #   set-window-option -g window-status-format "#[fg=${foreground-current},bg=${background-other},noitalics]#[fg=#c1e4f6,bg=${background-other}] #I #[fg=#c1e4f6,bg=${background-other}] #W#{?window_zoomed_flag,*Z,} #[fg=${background-current},bg=${background},noitalics]"
    #   set-window-option -g window-status-separator ""
    # }
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
