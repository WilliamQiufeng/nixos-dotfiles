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
      alsa-lib
      libpulseaudio
      libdecor
      wayland
    ];

    libraryPath = pkgs.lib.makeLibraryPath libs;
    openglDriverPath = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
  in
  {
    devShells.x86_64-linux.default = pkgs.mkShell {
      nativeBuildInputs = [ pkgs.dotnet-sdk_10 ];

      # This tells nix-ld where to find the libraries ONLY for this project
      shellHook = ''
        export NIX_LD_LIBRARY_PATH=${libraryPath}:${openglDriverPath}:$NIX_LD_LIBRARY_PATH
        export DOTNET_ROLL_FORWARD="LatestMajor"
        export NIX_LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$PWD/Quaver.Shared
        export LD_LIBRARY_PATH=${libraryPath}:${openglDriverPath}:$LD_LIBRARY_PATH:$PWD/Quaver.Shared
      '';
    };
  };
}
