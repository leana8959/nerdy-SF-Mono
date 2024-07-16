{
  description = "SF Mono patched with NerdFont characters";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    dotfiles = {
      url = "github:leana8959/.files";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };

        mkNerdFont = pkgs.callPackage (inputs.dotfiles + "/nix/custom/mkNerdFont.nix") { };

        sf-mono-src = pkgs.stdenvNoCC.mkDerivation {
          name = "SF-Mono";
          src = ./.;
          buildPhase = ''
            fontdir="$out"/share/fonts/opentype
            install -d $fontdir
            cp ./fonts/* "$fontdir"
          '';
        };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

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
