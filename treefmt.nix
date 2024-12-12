{pkgs, ...}: {
  programs.nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
  programs.nixfmt.package = pkgs.nixfmt-rfc-style;

  programs.deadnix.enable = true;
  programs.deadnix.package = pkgs.deadnix;

  programs.statix.enable = true;
  programs.statix.package = pkgs.statix;

  programs.mdformat.enable = true;
  programs.mdformat.package = pkgs.mdformat;

  programs.yamlfmt.enable = true;
}
