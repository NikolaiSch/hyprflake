{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.msi-gs62 # contains the unified BIOS version of `E16J9IMS`
    ./disko.nix
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "nvme" "sd_mod" "thunderbolt" "uas" "xhci_pci"];
    initrd.systemd.enable = true;
    kernelModules = [];
  };

  system.stateVersion = "24.11";
}
