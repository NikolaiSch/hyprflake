{ lib, config, ... }:
{
  options = {
    networking = {
      enable = lib.mkEnableOption "Enable network manager";
      hostName = lib.mkOption {
        description = "The hostname of the system.";
        type = lib.types.str;
        default = "nixos";
      };
    };
  };

  config = lib.mkIf config.networking.enable {
    networking = {
      networkmanager.enable = true;
      hostName = config.networking.hostName;
    };
  };
}
