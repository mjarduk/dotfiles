{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pulseaudio # pactl, for the volume keybinds
  ];
}
