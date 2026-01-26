{ pkgs, ... }:
{
  home.packages = with pkgs; [
    swaybg
    xwayland-satellite
    cava
    playerctl
    pavucontrol
    qpwgraph
    swaynotificationcenter
    mpv
  ];
  # ----- NIRI ------
  programs.alacritty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  xdg.configFile."niri/config.kdl".source = ../../config/niri.kdl;

  # ----- Waybar -----
  xdg.configFile."waybar" = {
    source = ../../config/waybar;
    recursive = true;
  };

  # ----- SwayNC -----
  services.swaync = import ../../config/swaync/config.nix { inherit pkgs; };
  xdg.configFile."swaync/style.css".source = ../../config/swaync/style.css;

  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit
}
