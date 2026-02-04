{
  config,
  pkgs,
  nix4vscode,
  pkgs-2505,
  ...
}:
{
  imports = [
    ../../config/obs/config.nix
    ../../config/nvidia/home.nix
    ../../packages/ime.nix
    ../../packages/shell/zsh.nix
    ../../packages/gnome/home.nix
    ../../packages/steam/home.nix
    ../../desktop/niri
    ../../packages/lunar-client/home.nix
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
    pkgs-2505.microsoft-edge # From 25.05 because Sync on work accounts break on 25.11
    discord
    spotify
    vscode
    qq
    wechat
    zotero
    localsend
    prismlauncher

    # Nix LSP
    nil

    # Tools
    gnumake
    unzip
    btop
    neofetch
    lshw
    nix-search-cli
    findutils
    javaPackages.compiler.openjdk21

    # .NET Development
    jetbrains.rider
    dotnet-sdk_10

    # Scala
    sbt-with-scala-native

    # IDEA
    jetbrains.idea
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
  # ----- VSCode -----
  programs.vscode = {
    enable = true;
    profiles.default.extensions = pkgs.nix4vscode.forVscode [
      "pinage404.nix-extension-pack"
      "ms-python.python"
      "ms-python.debugpy"
    ];
  };

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
