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
}
