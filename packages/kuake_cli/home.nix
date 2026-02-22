{ pkgs, ... }:

let
  kuake_cli = pkgs.callPackage ../../packages/kuake_cli/kuake_cli_1.3.7.nix {};  
in
{
  home.packages = [
    kuake_cli
  ];
}