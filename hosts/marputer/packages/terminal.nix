{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    ranger
    p7zip
  ];
}
