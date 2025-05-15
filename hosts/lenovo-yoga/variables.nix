{ config, lib, ... }: {
  imports = [
    # Choose your theme here:
    ../../themes/nixy.nix
  ];

  config.var = {
    hostname = "lenovo-yoga";
    username = "romek";
    configDirectory = "/home/" + config.var.username
      + "/Workspace/dots"; # The path of the nixos configuration directory

    keyboardLayout = "us";
    extraKeyboardLayouts = ",de,pl";

    location = "Berlin";
    timeZone = "Europe/Berlin";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "de_DE.UTF-8";

    git = {
      username = "romek";
      email = "contact@romek.codes";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;
    isLaptop = true; # If true battery is shown in hyprbar, otherwise not
    withGames = false; # If true, gaming related things are installed as well.
  };

  # Let this here
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
