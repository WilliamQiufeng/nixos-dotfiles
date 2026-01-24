{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix4vscode,
      ...
    }:
    {
      nixosConfigurations = {
        william = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
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
                extraSpecialArgs = { inherit nix4vscode; };
              };
            }
          ];
        };
      };
    };
}
