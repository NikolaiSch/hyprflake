{ config, lib, ... }:
{
  options = {
    audio = {
      enable = lib.mkEnableOption "Enable audio";
    };
  };

  config = lib.mkIf config.audio.enable {
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };
}
