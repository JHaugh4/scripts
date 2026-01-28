# To add to this:
# Add package
# Add package to symLinkJoin
# Call nix flake update
# Then push to git
# Then to a full rebuild
# Then do a home rebuild
{
  description = "Personal shell script flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

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
      python-init = pkgs.writeShellApplication {
        name = "_-python-init";
        runtimeInputs = [];
        text = builtins.readFile ./_-python-init.sh;
      };
      regexify = pkgs.writeShellApplication {
        name = "_-regexify";
        runtimeInputs = [pkgs.wl-clipboard];
        text = builtins.readFile ./_-regexify.sh;
        # Ignores warning about echo pipe sed.
        # This cannot be fixed as they suggest.
        excludeShellChecks = [ "SC2001" ];
      };
      replace-backticks = pkgs.writeShellApplication {
        name = "_-replace-backticks";
        runtimeInputs = [];
        text = builtins.readFile ./_-replace-backticks.sh;
      };
      all = pkgs.symlinkJoin { 
        name = "all";
        paths = [
          backup
          home-rebuild
          full-rebuild
          haskell-init
          simple-init
          python-init
          regexify
          replace-backticks
        ];
      };
      default = all;
    };
  };
}
