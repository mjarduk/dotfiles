{ pkgs, ... }: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      fontconfig
      freetype
      dbus
      expat
      glib
      libxkbcommon
      libx11
      libxext
      libxrender
      libxi
      libsm
      libice
      libxcb
      icu
      alsa-lib
      alsa-plugins
      libpulseaudio
      python314
      libglvnd
      libva
      fuse3
    ];
  };
}
