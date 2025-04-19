{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      home-manager,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (final: prev: { dd_lsp = self.packages.x86_64-linux.default; }) ];
      };
    in
    {
      packages.x86_64-linux.default = pkgs.haskellPackages.developPackage {
        root = ./src;
        name = "dd_lsp";
      };
      devShells.x86_64-linux.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          cabal-install
          ghcid
        ];
        inputsFrom = [ self.packages.x86_64-linux.default ];
      };

      homeConfigurations."ja@pc" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.stateVersion = "24.11";
            home.username = "ja";
            home.homeDirectory = "/home/ja";
            programs.home-manager.enable = true;
            programs.git.enable = true;
            programs.zsh.enable = true;
          }
          nixvim.homeManagerModules.nixvim
          ./nixvim.nix
        ];
      };

      overlays.default = final: prev: { dd_lsp = self.packages.x86_64-linux.default; };

      homeManagerModules.nixvim = {
        imports = [
          ./nixvim.nix
          #nixvim.homeManagerModules.nixvim
        ];
      };
    };
}
