{ settings, pkgs, ... }: {
  imports = [
      ./marcraft.nix
      ./servers.nix
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  boot.kernelParams = [
    "i915.enable_guc=3"
  ];

  environment.systemPackages = with pkgs; [
    clinfo
    pciutils
  ];

  users.users.${settings.username}.extraGroups = [
    "render"
    "video"
    "minecraft"
  ];
}
