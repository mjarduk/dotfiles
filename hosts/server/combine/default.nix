{ config, ... }:
{
  age.secrets.combine_garage_keys.file = ../../../secrets/combine_garage_keys.age;
  age.secrets.combine_grafana_secret = {
    file = ../../../secrets/combine_grafana_secret.age;
    owner = "grafana";
  };

  imports = [
    ./garage.nix
    ./wg.nix
    ./web.nix
    ./jenkins.nix
    ./polyglot-image.nix
    ./ghidra.nix
  ];

  services.prometheus = {
    enable = true;
    port = 9000;

    globalConfig.scrape_interval = "10s"; # "1m"
    scrapeConfigs = [
      {
        job_name = "s3";
        static_configs = [{
          targets = [ "localhost:3903" ];
        }];
      }
      {
        job_name = "minecraft-node";
        static_configs = [{
          targets = [ "192.168.125.180:9000" ];
        }];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
        enable_gzip = true;
      };
      security = {
        secret_key = "$__file{${config.age.secrets.combine_grafana_secret.path}}";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 9000 ];

  networking.nameservers = [ "9.9.9.9" "149.112.112.112" "77.88.8.8" ];
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
  networking.resolvconf.extraOptions = [ "timeout:2" ];
}
