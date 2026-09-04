{ config, ... }:
{
  services.jenkins = {
    enable = true;
  };

  virtualisation.docker.enable = true;
  users.users.jenkins.extraGroups = [ "docker" ];

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
