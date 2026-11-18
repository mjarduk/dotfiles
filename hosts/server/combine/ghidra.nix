{ pkgs, ... }:
let
  dataDir = "/var/lib/ghidra";
  jdk = pkgs.jdk21;
  ghidra = pkgs.ghidra;
  ghidraHome = "${ghidra}/lib/ghidra";
  serverData = "${ghidraHome}/Ghidra/Features/GhidraServer/data";
  yajsw = "${serverData}/yajsw-stable-13.18";

  startScript = pkgs.writeShellScript "ghidra-server-console" ''
    export java=${jdk}/lib/openjdk/bin/java
    export ghidra_home=${ghidraHome}
    export classpath_frag=${serverData}/classpath.frag
    export wrapper_tmpdir="''${TMPDIR:-/tmp}"
    exec "$java" -Xmx512M \
      -Djna_tmpdir="$wrapper_tmpdir" \
      -Djava.io.tmpdir="$wrapper_tmpdir" \
      -jar ${yajsw}/wrapper.jar -c ${dataDir}/server.conf
  '';
in {
  environment.systemPackages = [
    ghidra
  ];

  networking.firewall.allowedTCPPorts = [ 13100 13101 13102 ];

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
      StateDirectory = "ghidra";
      StateDirectoryMode = "0700";
      PrivateTmp = true;
      Environment = "JAVA_HOME=${jdk}/lib/openjdk";
      ExecStart = "${startScript}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
