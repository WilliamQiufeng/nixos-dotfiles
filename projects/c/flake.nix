{
  description = "C/C++ Dev Environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      # Define the VSCode extension list
      # We prefer Clangd for intellisense but keep C/C++ tools for debugging
      vscode-extensions = with pkgs.vscode-extensions; [
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        twxs.cmake
      ];
      vscode-with-extensions = pkgs.vscode-with-extensions.override {
        vscodeExtensions = vscode-extensions;
        vscode = pkgs.vscode;
      };
      code-wrapper = pkgs.writeShellScriptBin "code" ''
        exec ${vscode-with-extensions}/bin/code \
          --user-data-dir "$PWD/.vscode/user-data" \
          "$@"
      '';

    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          cmake
          gnumake
          ninja
          gcc
          clang-tools
          gdb
          code-wrapper
        ];

        # This tells nix-ld where to find the libraries ONLY for this project
        shellHook = "";
      };
    };
}
