{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    ranger
  ];
}
