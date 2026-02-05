{ noctalia, ... }:
{
  imports = [
    noctalia.homeModules.default
  ];
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {
      # configure noctalia here
      bar = {
        density = "compact";
        position = "top";
        showCapsule = false;
        widgets = {
          left = [
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "plugin:clipper";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = true;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Tray";
              drawerEnabled = false;
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        avatarImage = "/home/william/Pictures/ScreenSaver/miku3.png";
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "London, UK";
      };
      wallpaper = {
        enabled = false;
        overviewEnabled = false;
      };
      ui = {
        fontDefault = "JetBrainsMono Nerd Font Propo";
        fontFixed = "JetBrainsMono Nerd Font Propo";
      };
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          clipper = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 1;
      };
    };
    # this may also be a string or a path to a JSON file.
  };
}
