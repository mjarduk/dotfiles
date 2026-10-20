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
    qbittorrent

    flameshot
    yubikey-manager

    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
