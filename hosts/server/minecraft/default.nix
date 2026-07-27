{ settings, pkgs, ... }: {
  imports = [
      ./marcraft.nix
      ./servers.nix
  ];

  hardware.enableRedistributableFirmware = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  boot.kernelParams = [
    "i915.enable_guc=3"
  ];

  environment.systemPackages = with pkgs; [
    clinfo
    pciutils
    btop
  ];

  # services.prometheus.exporters.node = {
  #   enable = true;
  #   port = 9000;
  # };

  users.users.${settings.username}.extraGroups = [
    "render"
    "video"
    "minecraft"
  ];
}
