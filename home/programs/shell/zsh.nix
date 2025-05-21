# My shell configuration
{ pkgs, lib, config, ... }:
let fetch = config.theme.fetch; # neofetch, nerdfetch, pfetch
in {

  home.packages = with pkgs; [ bat ripgrep tldr sesh ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "laravel" "tmux" ];
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" "regexp" "root" "line" ];
    };
    historySubstringSearch.enable = true;

    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };

    # profileExtra = lib.optionalString (config.home.sessionPath != [ ]) ''
    #   export PATH="$PATH''${PATH:+:}${
    #     lib.concatStringsSep ":" config.home.sessionPath
    #   }"
    # '';

    # CHANGEME: for btop to show gpu usage 
    #may want to check the driver version with:
    #nix path-info -r /run/current-system | grep nvidia-x11
    #and 
    #nix search nixpkgs nvidia_x11
    # sessionVariables = {
    # LD_LIBRARY_PATH = lib.concatStringsSep ":" [
    #   "${pkgs.linuxPackages_latest.nvidia_x11_beta}/lib" # change the package name according to nix search result
    #   "$LD_LIBRARY_PATH"
    # ];
    # };

    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      v = "nvim .";
      c = "clear";
      clera = "clear";
      celar = "clear";
      e = "exit";
      cd = "z";
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --tree --no-quotes";
      sl = "ls";
      open = "${pkgs.xdg-utils}/bin/xdg-open";

      # git
      g = "lazygit";

      sail = "[ -f sail ] && sh sail || sh vendor/bin/sail";
      phpstan = "./vendor/bin/phpstan";
      pint = "./vendor/bin/pint";
    };

    # TODO: Why doesnt this work at all unless i specifically source zshrc manually?
    initContent = ''
      ZSH_TMUX_AUTOSTART=true

      bindkey -e
      ${if fetch == "neofetch" then
        pkgs.neofetch + "/bin/neofetch"
      else if fetch == "nerdfetch" then
        "nerdfetch"
      else if fetch == "pfetch" then
        "echo; ${pkgs.pfetch}/bin/pfetch"
      else
        ""}

      # search history based on what's typed in the prompt
      autoload -U history-search-end
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end
      bindkey "^[OA" history-beginning-search-backward-end
      bindkey "^[OB" history-beginning-search-forward-end

      # General completion behavior
      zstyle ':completion:*' completer _extensions _complete _approximate

      # Use cache
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

      # Complete the alias
      zstyle ':completion:*' complete true

      # Autocomplete options
      zstyle ':completion:*' complete-options true

      # Completion matching control
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' keep-prefix true

      # Group matches and describe
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-grouped false
      zstyle ':completion:*' list-separator '''
      zstyle ':completion:*' group-name '''
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*:matches' group 'yes'
      zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
      zstyle ':completion:*:messages' format '%d'
      zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
      zstyle ':completion:*:descriptions' format '[%d]'

      # Colors
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # case insensitive tab completion
      zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
      zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
      zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
      zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*' squeeze-slashes true

      # Sort
      zstyle ':completion:*' sort false
      zstyle ":completion:*:git-checkout:*" sort false
      zstyle ':completion:*' file-sort modification
      zstyle ':completion:*:eza' sort false
      zstyle ':completion:complete:*:options' sort false
      zstyle ':completion:files' sort false
    '';
  };
}
