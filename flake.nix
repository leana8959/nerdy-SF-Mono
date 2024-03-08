{
  description = "A customized nerd font of Iosevka, with Haskell and ML ligatures";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixunstable.url = "github:nixos/nixpkgs/nixos-unstable";
    dotfiles.url = "git+https://git.earth2077.fr/leana/.files?dir=nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixunstable,
    flake-utils,
    dotfiles,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      unstable = import nixunstable {inherit system;};

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
