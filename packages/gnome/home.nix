{
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
}