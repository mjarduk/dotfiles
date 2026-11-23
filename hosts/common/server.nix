{ settings, lib, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ settings.username ];
    };

    extraConfig = lib.optionalString (settings.sshPublic or false) ''
      MaxAuthTries 3
      PerSourcePenalties crash:3600s authfail:3600s max:86400s
    '';
  };

  security.auditd.enable = (settings.hardened or false);

  boot.kernel.sysctl = lib.optionalAttrs (settings.hardened or false) {
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "kernel.sysrq" = 0;
    "kernel.kptr_restrict" = 2;
    "kernel.perf_event_paranoid" = 3;
  };
}
