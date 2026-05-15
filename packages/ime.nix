{
  pkgs,
  ...
}:
{

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;

    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk # alternatively, kdePackages.fcitx5-qt
        qt6Packages.fcitx5-chinese-addons # table input method support
        fcitx5-nord # a color theme
      ];

      settings = {
        globalOptions = {
          "Hotkey/TriggerKeys" = {
            "0" = "Tools";
          };

          "Hotkey/EnumerateForwardKeys" = {
            "0" = "Tools";
          };

          "Hotkey" = {
            "EnumerateWithTriggerKeys" = "False";
            "EnumerateSkipFirst" = "False";
          };
        };

        inputMethod = {
          GroupOrder = {
            "0" = "Default";
          };

          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "pinyin";
          };

          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };

          "Groups/0/Items/1" = {
            Name = "pinyin";
            Layout = "";
          };
        };
      };

      # Optional, but recommended if ~/.config/fcitx5/config is overriding this.
      ignoreUserConfig = true;
    };
  };
}
