{
  inputs,
  outputs,
  stateVersion,
  ...
}: let
  laptopHostnames = [
    "msi-gp62"
  ];
  isLaptopHost = hostname: laptopHostnames.any (x: x == hostname);
  isISOHost = hostname: builtins.substring 0 4 hostname == "iso-";
in {
  # Helper function for generating home-manager configs
  mkHome = {
    hostname,
    username ? "vii",
    desktop ? "hyprland",
    platform ? "x86_64-linux",
  }: let
    isLaptop = isLaptopHost hostname;
    isISO = isISOHost hostname;
    isInstall = !isISO;
    isWorkstation = "" != desktop;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        hostPlatform = platform;
        inherit
          inputs
          outputs
          desktop
          hostname
          platform
          username
          stateVersion
          isInstall
          isLaptop
          isISO
          isWorkstation
          ;
      };
      modules = [../home-manager];
    };

  # Helper function for generating NixOS configs
  mkNixos = {
    hostname,
    username ? "vii",
    desktop ? "hyprland",
    hostPlatform ? "x86_64-linux",
  }: let
    isLaptop = isLaptopHost hostname;
    isISO = isISOHost hostname;
    isInstall = !isISO;
    isWorkstation = "" != desktop;
    tailNet = "vii.net";
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          username
          stateVersion
          isInstall
          isISO
          isLaptop
          isWorkstation
          tailNet
          ;
      };
      # If the hostname starts with "iso-", generate an ISO image
      modules = let
        cd-dvd =
          if (desktop == null)
          then inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          else inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix";
      in
        [
          ../nixos
        ]
        ++ inputs.nixpkgs.lib.optionals isISO [cd-dvd];
    };

  mkDarwin = {
    desktop,
    hostname ? "nikbook",
    username ? "vii",
    hostPlatform ? "aarch64-darwin",
  }: let
    isISO = false;
    isInstall = true;
    isLaptop = true;
    isWorkstation = true;
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          username
          isInstall
          isISO
          isLaptop
          isWorkstation
          hostPlatform
          ;
      };
      modules = [../darwin];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
