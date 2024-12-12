{
  description = "hyprflake";

  inputs = {
    # websurfx.url = "github://github:neon-mmd/websurfx";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      flake-parts,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (inputs) outputs;
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        nixosConfigurations = {
          "msi-gp62" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hosts/msi-gp62
              # "https://nix-community.github.io/home-manager/index.xhtml" # ch-nix-flakes
              home-manager.nixosModules.home-manager
            ];
          };
        };
      };

      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, config, ... }:
        let 
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

        {
          formatter = treefmtEval.config.build.wrapper;
          # for `nix flake check`
          checks = {
            formatting = treefmtEval.config.build.check self;
            statix = pkgs.statix;
            deadnix = pkgs.deadnix;
          };

          
        };
    };

}
