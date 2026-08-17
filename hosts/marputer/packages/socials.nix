{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ayugram-desktop
  ];
}
