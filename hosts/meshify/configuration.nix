{ config, ... }: {
  imports =
    [ ./variables.nix ../../nixos/shared.nix ./hardware-configuration.nix ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
