{ pkgs, ... }:
{
        programs.nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
        programs.nixfmt.package = pkgs.nixfmt-rfc-style;
        programs.shellcheck.enable = true;
        settings.formatter.shellcheck.options = [
          "-s"
          "bash"
        ];
    }
