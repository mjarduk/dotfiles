{ config, ... }:
{
  services.jenkins = {
    enable = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
  users.users.jenkins.extraGroups = [ "podman" ];

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
