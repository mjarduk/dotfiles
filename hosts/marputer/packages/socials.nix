{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ayugram-desktop
    vesktop
    halloy
    thunderbird
  ];
}
