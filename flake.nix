{
  description = "hyprflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

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
    let
      inherit (inputs) outputs;
      stateVersion = "24.11";
    in
    {
      nixosConfigurations = {
        gp62 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/gp62 ];
          stateVersion = stateVersion;
        };
      };

      homeConfigurations = {
        "vii@gp62" = home-manager.lib.homeManagerConfiguration {
          stateVersion = stateVersion;
          homeDirectory = "/home/vii";
          configuration = {
            imports = [ ./home ];
          };
        };
      };
    };
}
