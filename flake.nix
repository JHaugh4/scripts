{
  description = "Personal shell script flake";

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in rec {
    packages.x86_64-linux = {
      scripts = rec {
        backup = pkgs.writeShellApplication {
          name = "_-backup";
          runtimeInputs = [pkgs.restic];
          text = builtins.readFile ./_-backup.sh;
        };
        home-rebuild = pkgs.writeShellApplication {
          name = "_-home-rebuild";
          runtimeInputs = [];
          text = builtins.readFile ./_-home-rebuild.sh;
        };
        full-rebuild = pkgs.writeShellApplication {
          name = "_-full-rebuild";
          runtimeInputs = [];
          text = builtins.readFile ./_-full-rebuild.sh;
        };
        all = pkgs.symlinkJoin {
          name = "all";
          paths = [
            backup
            home-rebuild
            full-rebuild
          ];
        };
      };
    };
    defaultPackage.x86_64-linux = packages.x86_64-linux.scripts.all;
  };
}
