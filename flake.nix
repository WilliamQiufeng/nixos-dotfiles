{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs_2505.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    minegrub-world-sel-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs_2505,
      nixpkgs_unstable,
      home-manager,
      nix4vscode,
      noctalia,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-2505 = import nixpkgs_2505 {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs_unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        william = import ./hosts/william {
          inherit system;
          inherit home-manager;
          inherit inputs;
          inherit nixpkgs;
          inherit nix4vscode;
          inherit pkgs-2505;
          inherit pkgs-unstable;
          inherit noctalia;
        };
      };
    };
}
