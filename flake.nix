{
  description = "hyprflake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hardware.url = "github:nix-community/nixos-hardware";
  };

  outputs = { self, nixpkgs }: { };
}
