{inputs, ...}: {
  modifications = _final: prev: {
    hyprland = prev.hyprland.overrideAttrs (_old: rec {
      postPatch =
        _old.postPatch
        + ''
          sed -i 's|Exec=Hyprland|Exec=hypr-launch|' example/hyprland.desktop
        '';
    });

    hyprpicker = prev.hyprpicker.overrideAttrs (_old: rec {
      # https://github.com/hyprwm/hyprpicker/issues/92
      patches =
        (_old.patches or [])
        ++ [
          (prev.fetchpatch {
            url = "https://github.com/hyprwm/hyprpicker/commit/17e1ebe9dcb4157f1d3866f55d7fe55f20d979d0.diff";
            sha256 = "sha256-iXuBeJ2uz9DH1iYKWjvxZ+Q5hx4tHyfAkyO66g6zmDI=";
          })
        ];
    });
    wavebox = prev.wavebox.overrideAttrs (_old: rec {
      pname = "wavebox";
      version = "10.131.15-2";
      src = prev.fetchurl {
        url = "https://download.wavebox.app/stable/linux/deb/amd64/wavebox_${version}_amd64.deb";
        sha256 = "sha256-rGMkXs5w/NrIYOKPArCLBMUDoMnvQqggo91viyJUfj4=";
      };
    });
  };
}
