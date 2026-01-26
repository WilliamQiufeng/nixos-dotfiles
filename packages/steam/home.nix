{
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
}