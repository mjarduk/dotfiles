{ pkgs, ... }:
{
  systemd.services.homelab-polyglot-image = {
    description = "Build homelab:polyglot docker image";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    requires = [ "docker.service" ];
    path = [ pkgs.docker ];
    script = ''
      docker build -t homelab:polyglot ${./polyglot}
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
