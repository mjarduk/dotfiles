{ settings, pkgs, config, home-manager, inputs, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
    ./packages
    ./ntc.nix
    ./overlays.nix
    ./nix-ld.nix
  ];

  nix.settings = {
    http-connections = 128;
    connect-timeout = 5;
    narinfo-cache-negative-ttl = 0;
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.displayManager.ly.enable = true;
  services.displayManager.defaultSession = "none+i3";
  services.blueman.enable = true;
  services.udisks2.enable = true;

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
    corefonts
    times-newer-roman
  ];

  # force fontconfig to use monochrome emoji fonts like cozette's before color emojis
  fonts.fontconfig.localConf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <match target="pattern">
        <test name="lang" compare="contains">
          <string>und-zsye</string>
        </test>
        <edit name="color" mode="assign">
          <bool>false</bool>
        </edit>
      </match>
    </fontconfig>
  '';

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

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  programs.direnv.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ libfido2 yubikey-personalization hplipWithPlugin ];
  users.groups.plugdev = { };
  users.users.${settings.username}.extraGroups = [ "plugdev" "lp" "scanner" ];
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="1050", OWNER="pcscd", MODE="0660"
  '';

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "alacritty.desktop"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /usr/lib/dri - - - - /run/opengl-driver/lib/dri"
  ];
}
