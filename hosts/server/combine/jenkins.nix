{ config, ... }:
{
  services.jenkins = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  users.users.jenkins.extraGroups = [ "docker" ];

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
