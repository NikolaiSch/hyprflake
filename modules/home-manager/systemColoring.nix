{ lib, stylix, config,  ... }:
let 
  cfg = config.systemColoring
;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  options = {
    systemColoring.enable = lib.mkEnableOption "system coloring";

    systemColoring.wallpaperPath = lib.mkOption {
      description = "The path to the wallpaper image.";
      type = lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    lib.mkIf cfg.wallpaperPath != null {
      home.file.".wallpaper/wallpaper.jpg".source = cfg.wallpaperPath;

      stylix = {
        enable = true;
        image = cfg.wallpaperPath;
        polarity = "dark";
      };
    };
  };
}
