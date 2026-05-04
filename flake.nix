{
  description = "OIAK";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    librelane.url = "github:librelane/librelane";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-cache.fossi-foundation.org"
    ];
    extra-trusted-public-keys = [
      "nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs="
    ];
  };
  outputs = { self, nixpkgs, librelane, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = nixpkgs.lib.genAttrs systems;

      pkgsFor = system: import nixpkgs {
        inherit system;
      };
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = pkgsFor system;
          compile-verilog-files = pkgs.writeScriptBin "compile-verilog-files" ''
            #!/bin/sh
            set -euo pipefail

            mkdir -p verilog

            for file in alu/*.sv; do
              [ -e "$file" ] || continue
              base="$(basename "$file" .sv)"
              sv2v "$file" > "verilog/$base.v"
            done
            '';
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # verilog interpreter
              iverilog
              # idk
              gtkwave
              # verilog linter
              verible
              # convert systemverilog to verilog
              haskellPackages.sv2v
              # synthesis of verilog code into actual circuits
              yosys
              # viewing of netlist outputs produced by yosys
              netlistsvg
              compile-verilog-files
              just
              verilator
              # SMT solver
              yices
            ];

            inputsFrom = [ librelane.devShells.${system}.default ];
          };
        }
      );
    };
}
