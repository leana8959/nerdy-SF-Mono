{
  description = "A customized nerd font of Iosevka, with Haskell and ML ligatures";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    dotfiles = {
      url = "git+https://git.earth2077.fr/leana/.files?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixunstable.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    dotfiles,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      inherit (dotfiles.lib.${system}) mkNerdFont;

      sf-mono-src = pkgs.stdenvNoCC.mkDerivation {
        name = "SF-Mono";
        src = ./.;
        buildPhase = ''
          fontdir="$out"/share/fonts/truetype
          install -d $fontdir
          cp ./fonts/* "$fontdir"
        '';
      };
    in {
      formatter = pkgs.alejandra;

      packages = {
        SF-Mono = sf-mono-src;

        SF-Mono-nerd-font-mono = mkNerdFont {
          font = sf-mono-src;
          extraArgs = ["--name {/.}-NFM" "--use-single-width-glyphs"];
        };

        SF-Mono-nerd-font-propo = mkNerdFont {
          font = sf-mono-src;
          extraArgs = ["--name {/.}-NFP" "--variable-width-glyphs"];
        };
      };
    });
}
