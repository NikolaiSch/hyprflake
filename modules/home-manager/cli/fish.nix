{ lib, config, ... }:
{
  options = {
    fish.enable = lib.mkEnableOption "Fish shell";
  };

  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;
      prompt = lib.mkIf config.fish.prompt.enable { enable = true; };
    };
  };
}
