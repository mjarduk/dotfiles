{ pkgs, ... }:
let
  dataDir = "/var/lib/ghidra";
  jdk = pkgs.jdk21;
  ghidra = pkgs.ghidra;
in {
  environment.systemPackages = [
    ghidra
  ];

  networking.firewall.allowedTCPPorts = [ 13100 ];

  users.users.ghidra = {
    isSystemUser = true;
    group = "ghidra";
    home = dataDir;
    createHome = true;
  };
  users.groups.ghidra = {};

  systemd.services.ghidra-server = {
    description = "Ghidra Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "ghidra";
      Group = "ghidra";
      WorkingDirectory = dataDir;
      Environment = "JAVA_HOME=${jdk}/lib/openjdk";
      ExecStart = "${ghidra}/lib/ghidra/server/ghidraSvr console";
      Restart = "on-failure";
    };
  };
}
