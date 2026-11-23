{ ... }:
{
  imports = [ ./docker.nix ];

  services.jenkins.enable = true;
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
