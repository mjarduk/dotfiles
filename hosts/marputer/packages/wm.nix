{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    dex
    feh
    picom
    i3status
    dunst
  ];
}
