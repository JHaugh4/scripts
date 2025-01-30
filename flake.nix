{
  description = "Personal shell script flake";

  # inputs = {
  #   nixpkgs.url = ""
  # }

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = rec {
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
      haskell-init = pkgs.writeShellApplication {
        name = "_-haskell-init";
        runtimeInputs = [];
        text = builtins.readFile ./_-haskell-init.sh;
      };
      simple-init = pkgs.writeShellApplication {
        name = "_-simple-init";
        runtimeInputs = [];
        text = builtins.readFile ./_-simple-init.sh;
      };
      all = pkgs.symlinkJoin {
        name = "all";
        paths = [
          backup
          home-rebuild
          full-rebuild
          haskell-init
          simple-init
        ];
      };
      default = all;
    };
  };
}
