{
  system,
  home-manager,
  inputs,
  nixpkgs,
  nix4vscode,
  pkgs-2505,
  ...
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    {
      nixpkgs.overlays = [
        nix4vscode.overlays.default
      ];
    }
    (
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          (final: prev: {
            gnome-control-center = prev.gnome-control-center.overrideAttrs (old: {
              # Wrap the binary to always see GNOME as the desktop
              postFixup = (old.postFixup or "") + ''
                wrapProgram $out/bin/gnome-control-center \
                  --set XDG_CURRENT_DESKTOP GNOME
              '';
            });
          })
        ];
      }
    )
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.william = import ./home.nix;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit nix4vscode;
          inherit pkgs-2505;
        };
      };
    }
    inputs.minegrub-world-sel-theme.nixosModules.default
  ];
}
