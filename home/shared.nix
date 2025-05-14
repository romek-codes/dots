{ pkgs, config, inputs, lib, ... }: {
  imports = [
    # Programs
    ./programs/kitty
    ./programs/nvim
    ./programs/shell
    ./programs/fetch
    ./programs/git
    ./programs/git/signing.nix
    ./programs/spicetify
    ./programs/discord
    ./programs/firefox
    ./programs/thunar
    ./programs/lazygit
    ./programs/duckduckgo-colorscheme

    # Scripts
    ./scripts # All scripts

    # System (Desktop environment like stuff)
    ./system/hyprland
    ./system/hypridle
    ./system/hyprlock
    ./system/hyprpanel
    ./system/hyprpaper
    ./system/rofi
    ./system/zathura
    ./system/mime
    ./system/udiskie
    ./system/clipman

    ./gaming.nix
  ];

  home.packages = with pkgs; [
    # Apps
    rbw # Password manager
    # TODO: After finding out what is the alternative that is installed here, set up rbw to automatically use that instead.
    pinentry
    vlc # Video player
    blanket # White-noise app
    obsidian # Note taking app
    planify # Todolists
    gnome-calendar # Calendar
    textpieces # Manipulate texts
    curtail # Compress images
    resources
    gnome-clocks
    gnome-text-editor
    mpv # Video player
    figma-linux

    # Dev
    go
    nodejs
    python3
    jq
    just
    pnpm
    air

    # Utils
    zip
    unzip
    optipng
    jpegoptim
    pfetch
    btop
    fastfetch

    # Just cool
    peaclock
    cbonsai
    pipes
    cmatrix

    # Dev & Testing
    chromium
  ];
}
