{
  lib,
  config,
  ...
}: {
  options = {
    fish.enable = lib.mkEnableOption "Fish shell";

    fish.prompt.enable = lib.mkEnableOption "Enable starship prompt";
  };

  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;
      prompt = lib.mkIf config.fish.prompt.enable {enable = true;};
    };

    programs.starship = {
      enable = fish.prompt.enable;
    };
  };
}
