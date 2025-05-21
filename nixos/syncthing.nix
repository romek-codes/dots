{
  services = {
    syncthing = {
      enable = true;
      user = "romek";
      dataDir = "/home/romek/Documents"; # Default folder for new synced folders
      configDir =
        "/home/romek/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };
}
