{ pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
    (pkgs.python3Packages.buildPythonApplication {
      pname = "rofi-copyq";
      version = "0.1.0";
      src = pkgs.fetchFromGitHub {
        owner = "cjbassi";
        repo = "rofi-copyq";
        rev = "master";
        sha256 = "sha256-xDxdKitVDonNhoNPMAoHizoaijQj9UQGSCPhWJOcB1w=";
      };
      propagatedBuildInputs = with pkgs.python3Packages; [ ];
      doCheck = false;
    })
  ];

  systemd.user.services.copyq = {
    Unit = {
      Description = "CopyQ, a clipboard manager";
      Documentation = [ "man:copyq(5)" ];
      Wants = [ "graphical-session.target" ];
      Requires = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.copyq}/bin/copyq";
      KillMode = "process";
      KillSignal = "SIGINT";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
  xdg.configFile."copyq/copyq.conf".source = ./copyq.conf;
}
