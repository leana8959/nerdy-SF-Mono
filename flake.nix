{
  description = "SF Mono patched with NerdFont characters";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    dotfiles.url = "git+https://git.earth2077.fr/leana/.files";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};

        mkNerdFont = pkgs.callPackage inputs.dotfiles.lib.mkNerdFont {};

        sf-mono-src = pkgs.stdenvNoCC.mkDerivation {
          name = "SF-Mono";
          src = ./fonts;
          buildPhase = ''
            fontdir="$out"/share/fonts/opentype
            install -d $fontdir
            cp ./* "$fontdir"
          '';
        };
      in {
        formatter = pkgs.alejandra;

        packages = {
          SF-Mono = sf-mono-src;

          SF-Mono-nerd-font-mono = mkNerdFont {
            font = sf-mono-src;
            extraArgs = [
              "--name {/.}-NFM"
              "--use-single-width-glyphs"
            ];
          };

          SF-Mono-nerd-font-propo = mkNerdFont {
            font = sf-mono-src;
            extraArgs = [
              "--name {/.}-NFP"
              "--variable-width-glyphs"
            ];
          };
        };
      }
    );
}
