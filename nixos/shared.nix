{ config, lib, ... }: {
  imports = [
    # Mostly system related configuration
    ./audio.nix
    ./bluetooth.nix
    ./fonts.nix
    ./home-manager.nix
    ./docker.nix
    ./nix.nix
    ./systemd-boot.nix
    ./sddm.nix
    ./users.nix
    ./utils.nix
    ./tailscale.nix
    ./hyprland.nix
    ./steam.nix
  ];
}
