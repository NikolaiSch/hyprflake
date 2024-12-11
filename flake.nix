{
  description = "hyprflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }:
    {
      nixosConfigurations = {
        gp62 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            inherit (inputs);
            ./hosts/gp62
            # "https://nix-community.github.io/home-manager/index.xhtml" # ch-nix-flakes
            home-manager.nixosModules.home-manager
            # {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users.vii = import ./vii.nix;
            # }
          ];
        };
      };
    };
}
