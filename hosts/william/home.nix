{
  config,
  pkgs,
  nix4vscode,
  pkgs-2505,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ../../config/obs/config.nix
    ../../config/nvidia/home.nix
    ../../packages/shell/zsh.nix
    ../../packages/gnome/home.nix
    ../../packages/steam/home.nix
    ../../desktop/niri
    ../../packages/lunar-client/home.nix
    ../../packages/rider/home.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "william";
  home.homeDirectory = "/home/william";

  home.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake '/home/william/nixos-dotfiles#william'";
    enable_proxy = "export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897";
  };

  # NPM
  home.file.".npmrc".text = ''
    prefix = ''${HOME}/.npm-packages
  '';
  home.sessionPath = [
    "$HOME/.npm-packages/bin"
  ];
  home.sessionVariables = {
    NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
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
    wireshark
    clash-verge-rev
    netease-cloud-music-gtk

    # Nix LSP
    nil

    # Tools
    gnumake
    unzip
    btop
    fastfetch
    lshw
    nix-search-cli
    findutils
    brightnessctl
    javaPackages.compiler.openjdk21
    nodejs_24
    bubblewrap

    # Scala
    sbt-with-scala-native

    # IDEA
    (jetbrains.idea.override {
      vmopts = "-Dawt.toolkit.name=WLToolkit";
    })

    # GoLand
    (jetbrains.goland.override {
      vmopts = "-Dawt.toolkit.name=WLToolkit";
    })

    # Godot
    pkgs-unstable.godot-mono
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
      "rust-lang.rust-analyzer"
      "njpwerner.autodocstring"
      "ms-python.black-formatter"
      "ms-python.vscode-pylance"
      "openai.chatgpt"
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
