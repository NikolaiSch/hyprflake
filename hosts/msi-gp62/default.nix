{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.msi-gs62 # contains the unified BIOS version of `E16J9IMS`
  ];

  disk = 
    ./disko.nix
;
}
