{
  description = "hyprflake";

  inputs = {
    # websurfx.url = "github://github:neon-mmd/websurfx";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-parts,
    treefmt-nix,
    nixos-hardware,
    git-hooks,
    ...
  } @ inputs: let
    inherit (self) outputs;
    stateVersion = "24.11";
    helper = import ./lib {inherit inputs outputs stateVersion;};
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.treefmt-nix.flakeModule
        # inputs.git-hooks.flakeModule
      ];

      flake = {
        nixosConfigurations = {
          "msi-gp62" = helper.mkNixos {
            hostname = "msi-gp62";
            desktop = "hyprland";
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

      perSystem = {
        pkgs,
        config,
        system,
        ...
      }: let
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        pre-commit-run = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = import ./pre-commit.nix;
        };
      in {
        formatter = pkgs.alejandra;
        # for `nix flake check`
        checks = {
          formatting = treefmtEval.config.build.check self;
          pre-commit = pre-commit-run;
        };

        treefmt = import ./treefmt.nix {inherit pkgs;};
      };
    };
}
