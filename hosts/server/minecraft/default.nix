{ settings, pkgs, ... }: {
  imports = [
      ./marcraft.nix
      ./servers.nix
  ];

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  environment.systemPackages = with pkgs; [
    clinfo
    pciutils
  ];

  users.users.${settings.username}.extraGroups = [
    "render"
    "video"
  ];
}
