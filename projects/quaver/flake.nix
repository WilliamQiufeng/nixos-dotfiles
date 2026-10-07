{
  description = "Quaver Dev Environment";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
  let
    pkgs = import nixpkgs { 
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    
    # The libraries Quaver crashes without
    libs = with pkgs; [
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
      mesa
      vulkan-loader
      alsa-lib
      libpulseaudio
      wayland
      wayland-protocols
      libdecor
      libxkbcommon
      dbus
    ];

    libraryPath = pkgs.lib.makeLibraryPath libs;
    openglDriverPath = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
    dotnetSdk = pkgs.dotnetCorePackages.combinePackages [
      pkgs.dotnet-sdk_10
      pkgs.dotnetCorePackages.sdk_8_0
    ];
  in
  {
    devShells.x86_64-linux.default = pkgs.mkShell {
      nativeBuildInputs = [ dotnetSdk ];

      # This tells nix-ld where to find the libraries ONLY for this project
      shellHook = ''
        export NIX_LD_LIBRARY_PATH=${libraryPath}:${openglDriverPath}:$NIX_LD_LIBRARY_PATH
        export DOTNET_ROOT=${dotnetSdk}/share/dotnet
        export DOTNET_ROLL_FORWARD="LatestMajor"
        export SDL_VIDEO_X11_WMCLASS=Quaver
        export NIX_LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$PWD/Quaver.Shared
        export LD_LIBRARY_PATH=${libraryPath}:${openglDriverPath}:$LD_LIBRARY_PATH:$PWD/Quaver.Shared
      '';
    };
  };
}
