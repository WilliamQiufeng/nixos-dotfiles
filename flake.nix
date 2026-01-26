{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs_2505.url = "github:nixos/nixpkgs/nixos-25.05";
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
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs_2505,
      home-manager,
      nix4vscode,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-2505 = import nixpkgs_2505 {
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
        };
      };
    };
}
