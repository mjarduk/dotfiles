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
      python314
      libglvnd
      libva
    ];
  };
}
