{
  config,
  pkgs,
  nix4vscode,
  ...
}:

let
  mkSoundScript =
    name: audioFile:
    pkgs.writeShellScript name ''
      PATH=$PATH:${pkgs.swaynotificationcenter}/bin:${pkgs.mpv}/bin
      # Check Do Not Disturb state
      state=$(swaync-client -D)
      if [[ "$state" == "true" ]]; then
          exit 0
      fi
      # Play the audio file passed from Nix
      mpv --no-terminal ${audioFile}
    '';
in
{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "william";
  home.homeDirectory = "/home/william";

  home.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake '/home/william/nixos-dotfiles#william'";
  };

  home.packages = with pkgs; [
    microsoft-edge
    discord-ptb
    spotify
    vscode
    nil
    swaybg
    xwayland-satellite
    cava
    playerctl
    pavucontrol
    qpwgraph
    swaynotificationcenter
    mpv
    btop
    neofetch
  ];

  # ----- GIT -----
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "WilliamQiufeng";
        email = "williamqiufeng@outlook.com";
      };
    };
  };
  programs.direnv.enable = true;
  programs.pay-respects = {
    enable = true;
  };

  # ----- NIRI ------
  programs.alacritty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  xdg.configFile."niri/config.kdl".source = config/niri.kdl;

  # ----- Waybar -----
  xdg.configFile."waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink config/waybar;
  };

  # ----- SwayNC -----
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 2;
      timeout-critical = 0;
      fit-to-screen = false;
      control-center-width = 500;
      control-center-height = 800;
      notification-window-width = 440;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;

      scripts = {
        message-sound = {
          exec = "${mkSoundScript "message" config/swaync/sound/message.ogg}";
          app-name = "QQ|Google-chrome";
        };
        complete-sound = {
          exec = "${mkSoundScript "complete" config/swaync/sound/complete.ogg}";
          app-name = "alixby3|com.xunlei.download|baidunetdisk";
        };
        Low-sound = {
          exec = "${mkSoundScript "normal" config/swaync/sound/normal.oga}";
          urgency = "Low";
        };
        Normal-sound = {
          exec = "${mkSoundScript "normal" config/swaync/sound/normal.oga}";
          urgency = "Normal";
        };
        Critical-sound = {
          exec = "${mkSoundScript "critical" config/swaync/sound/critical.oga}";
          urgency = "Critical";
        };
      };

      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notification Center";
          clear-all-button = true;
          button-text = "󰆴 Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 1;
          text = "Notification Center";
        };
        mpris = {
          image-size = 96;
          image-radius = 7;
        };
      };
    };
  };
  xdg.configFile."swaync/style.css".source = config/swaync/style.css;

  # ----- VSCode -----
  programs.vscode = {
    enable = true;
    profiles.default.extensions = pkgs.nix4vscode.forVscode [
      "pinage404.nix-extension-pack"
      "ms-python.python"
    ];
  };

  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit

  # Gnome Terminal
  programs.gnome-terminal = {
    enable = true;
    profile = {
      "b5d2f695-5555-4841-9107-3de3acedf9d5" = {
        default = true;
        visibleName = "Terminal";
        font = "Fira Code Nerd Font 12";
        customCommand = "zsh";
      };
    };
  };

  # GNOME Dark Theme
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh.enable = true;
  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
    ];
    theme = "robbyrussell";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk # alternatively, kdePackages.fcitx5-qt
      qt6Packages.fcitx5-chinese-addons # table input method support
      fcitx5-nord # a color theme
    ];
  };

}
