{
  config,
  pkgs,
  nix4vscode,
  ...
}:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports = [
    ./config/obs/config.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "william";
  home.homeDirectory = "/home/william";

  home.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake '/home/william/nixos-dotfiles#william'";
  };

  home.packages = with pkgs; [
    # Git Credential Manager
    git-credential-manager

    # Apps
    microsoft-edge
    discord-ptb
    spotify
    vscode

    # Nix LSP
    nil

    # Desktop
    swaybg
    xwayland-satellite
    cava
    playerctl
    pavucontrol
    qpwgraph
    swaynotificationcenter
    mpv
    unzip

    # Tools
    btop
    neofetch
    lshw
    nvtopPackages.full
    nix-search-cli

    # .NET Development
    jetbrains.rider
    dotnet-sdk_10

    # Scala
    sbt-with-scala-native

    # IDEA
    jetbrains.idea

    # NVIDIA
    nvidia-offload
  ];

  # ----- GIT -----
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "WilliamQiufeng";
        email = "williamqiufeng@outlook.com";
      };
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };
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
    source = config/waybar;
    recursive = true;
  };

  # ----- SwayNC -----
  services.swaync = import ./config/swaync/config.nix { inherit pkgs; };
  xdg.configFile."swaync/style.css".source = config/swaync/style.css;

  # ----- VSCode -----
  programs.vscode = {
    enable = true;
    profiles.default.extensions = pkgs.nix4vscode.forVscode [
      "pinage404.nix-extension-pack"
      "ms-python.python"
    ];
  };

  xdg.desktopEntries = {
    steam = {
      name = "Steam";
      exec = "steam %U";
      icon = "steam";
      terminal = false;
      categories = [
        "Network"
        "FileTransfer"
        "Game"
      ];
      mimeType = [
        "x-scheme-handler/steam"
        "x-scheme-handler/steamlink"
      ];
      settings = {
        PrefersNonDefaultGPU = "false";
      };
    };
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

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
