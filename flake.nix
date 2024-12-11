{
  description = "hyprflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nix-community/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.gp62 = nixpkgs.lib.nixosSystem {
        inherit (inputs) outputs;

        system = "x86_64-linux";
        modules = [ ./hosts/gp62 ];
      };

      # homeConfigurations."nikolai@gp62" = {
      #   system = "x86_64-linux";
      #   modules = [ ];
      # };
    };
}
