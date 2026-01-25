{ pkgs, ... }:

{
  home.file.".config/obs-studio/input-overlay-presets" = {
    source = ./input-overlay-presets;
    recursive = true;
  };

  # input-overlay folder is not created by default,
  # which would result in a crash!
  # see https://github.com/univrsal/input-overlay/issues/356
  home.file.".config/obs-studio/plugin_config/input-overlay/.keep".text = "";

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
