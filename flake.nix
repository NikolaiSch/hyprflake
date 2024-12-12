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


    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];

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
        { pkgs, config, system,  ... }:
        let
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          formatter = treefmtEval.config.build.wrapper;
          # for `nix flake check`
          checks = {
            formatting = treefmtEval.config.build.check self;
            pre-commit = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = import ./pre-commit.nix;
          };
          };

          treefmt = import ./treefmt.nix { inherit pkgs; };


        };
    };

}
