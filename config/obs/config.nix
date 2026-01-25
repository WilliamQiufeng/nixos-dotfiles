{ pkgs, ... }:

{
  home.file.".config/obs-studio/input-overlay-presets" = {
    source = ./input-overlay-presets;
    recursive = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      input-overlay
    ];
  };
}
