{ pkgs, lib, ... }:

let
  extra-path = with pkgs; [
    dotnetCorePackages.sdk_6_0
    dotnetPackages.Nuget
    mono
    msbuild
    # Add any extra binaries you want accessible to Rider here
  ];

  extra-lib = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    icu
    openssl
    xorg.libX11
    xorg.libXi
    xorg.libXext
    xorg.libXrandr
    xorg.libXcursor
    glib
    SDL2
    libGL
    libglvnd
    alsa-lib
    libpulseaudio
    libdecor
    wayland
  ];

  opengl-driver-lib = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";

  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall = ''
      # Wrap rider with extra tools and libraries
      mv $out/bin/rider $out/bin/.rider-toolless
      makeWrapper $out/bin/.rider-toolless $out/bin/rider \
        --argv0 rider \
        --prefix PATH : "${lib.makeBinPath extra-path}" \
        --prefix NIX_LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}:${opengl-driver-lib}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}:${opengl-driver-lib}"

      # Making Unity Rider plugin work!
      # The plugin expects the binary to be at /rider/bin/rider,
      # with bundled files at /rider/
      # It does this by going up two directories from the binary path
      # Our rider binary is at $out/bin/rider, so we need to link $out/rider/ to $out/
      shopt -s extglob
      ln -s $out/rider/!(bin) $out/
      shopt -u extglob
    ''
    + attrs.postInstall or "";
  });
in
{
  home.packages = with pkgs; [

    # .NET Development

    dotnet-sdk_10
    (rider.override {
      vmopts = "-Dawt.toolkit.name=WLToolkit";
    })

    # Unity
    mono
    unityhub
  ];

  # For Unity to discover Rider as an editor
  home.file.".local/share/applications/jetbrains-rider.desktop".source =
    let
      desktopFile = pkgs.makeDesktopItem {
        name = "jetbrains-rider";
        desktopName = "Rider";
        exec = "\"${rider}/bin/rider\"";
        icon = "rider";
        type = "Application";
        # Don't show desktop icon in search or run launcher
        extraConfig.NoDisplay = "true";
      };
    in
    "${desktopFile}/share/applications/jetbrains-rider.desktop";

}
