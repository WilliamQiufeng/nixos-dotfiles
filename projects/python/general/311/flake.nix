{
  description = "Python 3.11 development environment";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Adjust to your system
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          python311
          python311Packages.pip
          python311Packages.virtualenv
          stdenv.cc.cc.lib
          zlib
        ];

        shellHook = ''
          # Create venv if it doesn't exist
          if [ ! -d ".venv" ]; then
            python -m venv .venv
          fi
          
          source .venv/bin/activate
          
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib ]}:$LD_LIBRARY_PATH"
          
          echo "🐍 Python dev environment loaded!"
          python --version
        '';
      };
    };
}