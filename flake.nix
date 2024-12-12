{
  description = "hyprflake";

  inputs = {
    # websurfx.url = "github://github:neon-mmd/websurfx";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      flake-parts,
      ...
    }@inputs:
    let
      inherit (inputs) outputs;
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {

        debug = true;

        nixosConfigurations = {
          gp62 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hosts/gp62

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
        {
          formatter = pkgs.nixfmt-rfc-style;

          checks.statix = pkgs.statix;
          checks.deadnix = pkgs.deadnix;
        };
    };

}
