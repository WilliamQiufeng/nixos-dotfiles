{
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ../../packages/gnome/configuration.nix
    ../../packages/steam/configuration.nix
    ./graphics.nix
    ./hardware-configuration.nix
    ./bluetooth.nix
  ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
    minegrub-world-sel = {
      enable = true;
      customIcons = with config.system; [
        {
          inherit name;
          lineTop = with nixos; distroName + " " + codeName + " (" + version + ")";
          lineBottom = "Survival Mode, No Cheats, Version: " + nixos.release;
          # Icon: you can use an icon from the remote repo, or load from a local file
          imgName = "nixos";
          # customImg = builtins.path {
          #   path = ./nixos-logo.png;
          #   name = "nixos-img";
          # };
        }
      ];
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  programs.niri.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 2048;
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.william = {
    isNormalUser = true;
    description = "William";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;

  };

  systemd.user.services.swaybg = {
    enable = true;
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];
    description = "Sway BG";
    serviceConfig = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${../../config/swaybg/interlude_16.png}";
      Restart = "on-failure";
    };
    wantedBy = [ "graphical-session.target" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.zsh.enable = true;

  # Use Vim as default editor
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  programs.nix-ld = {
    enable = true;
    # Sets up libraries that unpatched binaries commonly need
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      icu # Important for dotnet
      openssl # Important for dotnet
      xorg.libX11
      xorg.libXi
      xorg.libXext
      xorg.libXrandr
      xorg.libXcursor
      glib

      steam
      SDL2
      libGL
      libglvnd
      alsa-lib
      libpulseaudio
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      wget
    ];

    # For Electron Apps to use IMEs on Wayland
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    nerd-fonts.fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

}
