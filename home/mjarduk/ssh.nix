{ ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
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
