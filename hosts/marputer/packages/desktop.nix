{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    syncthingtray
    overskride

    keepassxc
    xscreensaver
    rofi

    obsidian

    vlc
    obs-studio
    qbittorrent

    libreoffice
    inkscape

    flameshot
    yubikey-manager

    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
