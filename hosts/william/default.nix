{
  system,
  home-manager,
  inputs,
  nixpkgs,
  nix4vscode,
  pkgs-2505,
  pkgs-unstable,
  ...
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    {
      nixpkgs.overlays = [
        nix4vscode.overlays.default
        (final: prev: {
          qq = prev.qq.overrideAttrs (old: {
            src = prev.fetchurl {
              url = "https://github.com/libzonda/Linux-QQ-release/releases/download/3.2.27/QQ_3.2.27_260401_amd64_01.deb";
              hash = "sha256-iI5gc0VSZAzab2B+w1I/6idSD/zx45Ou+uyqSJzCC+c=";
            };
          });
        })
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
          inherit pkgs-unstable;
        };
      };
    }
    inputs.minegrub-world-sel-theme.nixosModules.default
  ];
}
