{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    syncthingtray
    udiskie
    keepassxc
    xscreensaver
    rofi
    vicinae
    flameshot
    yubikey-manager
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
