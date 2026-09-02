{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    syncthingtray
    udiskie

    keepassxc
    xscreensaver
    rofi

    obsidian

    vlc
    vicinae

    flameshot
    yubikey-manager

    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
