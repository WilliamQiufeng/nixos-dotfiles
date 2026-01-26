{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lunar-client
  ];

  xdg.desktopEntries = {
    lunarclient = {
      name = "Lunar Client";
      exec = "lunarclient --disable-gpu-sandbox --ozone-platform=x11 %U";
      icon = "lunarclient";
      terminal = false;
      categories = [
        "Network"
        "Game"
      ];
    };
  };
}