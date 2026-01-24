{
  config,
  pkgs,
  nix4vscode,
  ...
}:

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
    fcitx5
    fcitx5-rime
    cava
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
    source = config.lib.file.mkOutOfStoreSymlink "/home/william/nixos-dotfiles/config/waybar";
  };

  # ----- VSCode -----
  programs.vscode = {
    enable = true;
    extensions = pkgs.nix4vscode.forVscode [
      "pinage404.nix-extension-pack"
      "ms-python.python"
    ];
  };

  services.mako.enable = true; # notification daemon
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

}
