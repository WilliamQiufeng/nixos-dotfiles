{pkgs, ...}:
{
  home.packages = with pkgs; [
    cliphist
    wl-clipboard
  ];
  services.cliphist = {

    enable = true;

    systemdTargets = [ "graphical-session.target" ];

    extraOptions = [
      "-max-dedupe-search"
      "10"
      "-max-items"
      "500"
    ];
    allowImages = true;

  };
}
