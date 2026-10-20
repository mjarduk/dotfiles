{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    alacritty
    ranger
    ffmpeg-full
    p7zip
  ];
}
