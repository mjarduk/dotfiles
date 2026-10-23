{ pkgs, lib, ... }:
let
  # Succeeds only on the home LAN, where combine answers directly.
  atHome = "${pkgs.netcat}/bin/nc -z -w 1 192.168.125.125 22 2>/dev/null";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      # Off the home LAN, reach combine through the router's port forward,
      # and everything else by jumping through combine. Must come before
      # `combine`, since the first HostName/Port set wins.
      away-combine = lib.hm.dag.entryBefore [ "combine" ] {
        header = "Match host combine !exec \"${atHome}\"";
        HostName = "tcp.marduk.ru";
        Port = 2222;
      };
      away-jump = {
        header = "Match host mc,git !exec \"${atHome}\"";
        ProxyJump = "combine";
      };
      combine = {
        HostName = "192.168.125.125";
        User = "mjarduk";
      };
      mc = {
        HostName = "192.168.125.180";
        User = "mjarduk";
      };
      git = {
        HostName = "192.168.125.125";
        Port = 23231;
        User = "mjarduk";
      };
      # GitHub's port 22 is dropped by the AmneziaVPN exit node; use the
      # port-443 SSH endpoint instead. Transparent to `ssh git@github.com`
      # and to git over SSH.
      "github.com" = {
        HostName = "ssh.github.com";
        Port = 443;
        User = "git";
      };
      "*" = {
        AddKeysToAgent = "no";
        Compression = false;
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
        ForwardAgent = false;
        HashKnownHosts = false;
        SetEnv = {
          TERM = "xterm-256color";
        };
        ServerAliveCountMax = 3;
        ServerAliveInterval = 0;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        IdentityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_ed25519_sk_rk"
        ];
      };
    };
  };
}
