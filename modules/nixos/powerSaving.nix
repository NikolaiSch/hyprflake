{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    powerSaving = {
      enable = lib.mkEnableOption "Enable power saving";
      intelCpu = lib.mkEnableOption "Enable Intel CPU power saving";
    };
  };

  config = lib.mkIf config.powerSaving.enable {
    powerManagement = {
      enable = true;
    };
    # https://wiki.nixos.org/wiki/Power_Management
    services.udev.extraRules =
      let
        mkRule = as: lib.concatStringsSep ", " as;
        mkRules = rs: lib.concatStringsSep "\n" rs;
      in
      mkRules ([
        (mkRule [
          ''ACTION=="add|change"''
          ''SUBSYSTEM=="block"''
          ''KERNEL=="sd[a-z]"''
          ''ATTR{queue/rotational}=="1"''
          ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 41 /dev/%k"''
        ])
      ]);

    systemd.sleep.extraConfig = ''
      HibernateDelaySec=1h
    '';

    services.thermald.enable = true;

    services.tlp.enable = true;
    powerManagement.powertop.enable = true;
  };
}
