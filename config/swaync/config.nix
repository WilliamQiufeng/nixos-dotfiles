{ pkgs, ... }:
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
        exec = "${mkSoundScript "message" ./sound/message.ogg}";
        app-name = "QQ|Google-chrome";
      };
      complete-sound = {
        exec = "${mkSoundScript "complete" ./sound/complete.ogg}";
        app-name = "alixby3|com.xunlei.download|baidunetdisk";
      };
      Low-sound = {
        exec = "${mkSoundScript "normal" ./sound/normal.oga}";
        urgency = "Low";
      };
      Normal-sound = {
        exec = "${mkSoundScript "normal" ./sound/normal.oga}";
        urgency = "Normal";
      };
      Critical-sound = {
        exec = "${mkSoundScript "critical" ./sound/critical.oga}";
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
}
