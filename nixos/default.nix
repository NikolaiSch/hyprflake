{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops

    ./default.nix
  ];
}
