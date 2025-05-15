# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{ lib, pkgs, ... }:
let
  # plugins = pkgs.tmuxPlugins // pkgs.callPackage ./custom-plugins.nix { };
  tmuxConf = lib.readFile ./tmux.conf;
in {
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    prefix = "C-s";
    escapeTime = 0;
    terminal = "kitty";
    keyMode = "vi";

    extraConfig = tmuxConf;

    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.sensible
      tmuxPlugins.yank
      # tmuxPlugins.tokyo-night-tmux
    ];
  };
}
