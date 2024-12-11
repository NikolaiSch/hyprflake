{
  description = "hyprflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nix-community/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/archive/master.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.gp62 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/gp62/default.nix ];
      };

      homeConfigurations."nikolai@gp62" = {
        system = "x86_64-linux";
        modules = [ ];
      };
    };
}
