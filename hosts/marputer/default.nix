{ settings, pkgs, lib, home-manager, inputs, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
    ./packages
  ];

  home-manager.users.mjarduk = {
    imports = [ ../../home/mjarduk ./i3.nix ./shell.nix ./termfilechooser.nix ];
  };
  home-manager.backupFileExtension = ".bak";
  home-manager.extraSpecialArgs = {
    homeDirectory = "/home/mjarduk";
    inherit inputs;
  };

  networking.networkmanager.enable = true;

  services.syncthing = {
    enable = true;
    user = "mjarduk";
    group = "users";
    dataDir = "/home/mjarduk";
    configDir = "/home/mjarduk/.local/state/syncthing";
    openDefaultPorts = true;
  };

  time.timeZone = "Europe/Moscow";

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;

  services.displayManager.ly.enable = true;
  services.displayManager.defaultSession = "none+i3";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };

  fonts.packages = with pkgs; [
    cozette
    noto-fonts
    twemoji-color-font
    liberation_ttf
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
    config.common."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
  };

  hardware.enableRedistributableFirmware = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  programs.amnezia-vpn.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.udev.packages = with pkgs; [ libfido2 yubikey-personalization ];
  users.groups.plugdev = { };
  users.users.${settings.username}.extraGroups = [ "plugdev" ];
  programs.gnupg.agent.enable = true;

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
      qt6.qtbase
      qt6.qtsvg
      qt6.qtwayland
      libx11
      libxext
      libxrender
      libxi
      libsm
      libice
      libxcb
      python313
    ];
  };
}
