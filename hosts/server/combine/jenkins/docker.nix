{ config, lib, ... }:
let
  uid = toString config.users.users.jenkins.uid;
  runtimeDir = "/run/user/${uid}";
  userManager = "user@${uid}.service";
  dockerHost = "unix://${runtimeDir}/docker.sock";
  docker = config.virtualisation.docker.rootless.package;
  imageUnit = "homelab-polyglot-image.service";
in
{
  virtualisation.docker = {
    enable = false;
    rootless.enable = true;
  };

  users.users.jenkins = {
    autoSubUidGidRange = true;
    linger = true;
  };

  systemd.user.services.docker.unitConfig.ConditionUser = lib.mkForce "jenkins";

  services.jenkins = {
    environment.DOCKER_HOST = dockerHost;
    packages = [ docker ];
  };

  systemd.services.jenkins = {
    wants = [ imageUnit ];
    after = [ imageUnit ];
  };

  systemd.services.homelab-polyglot-image = {
    description = "Build homelab:polyglot in Jenkins's rootless Docker daemon";
    after = [ userManager "network-online.target" ];
    wants = [ "network-online.target" ];
    requires = [ userManager ];
    path = [ docker ];
    environment = {
      DOCKER_HOST = dockerHost;
      XDG_RUNTIME_DIR = runtimeDir;
    };
    script = ''
      ${config.systemd.package}/bin/systemctl --user start docker.service
      docker build -t homelab:polyglot ${./polyglot}
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "15min";
      User = "jenkins";
      Group = config.services.jenkins.group;
    };
  };
}
