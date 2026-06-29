{ pkgs, ... }: {
  services.fcgiwrap.instances.nginx = {
    # enable = true;
    socket = {
      type = "unix";
      address = "/run/fcgiwrap/fcgiwrap.sock";
      user = "nginx";
      group = "nginx";
    };
    process = {
      user = "nginx";
      group = "nginx";
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/marduk.ru/ 0744 nginx nginx -"
    "d /srv/marduk.ru/cgi-bin 0744 nginx nginx -"
    "d /srv/marduk.ru/public 0744 nginx nginx -"
  ];

  services.nginx = {
    enable = true;
    virtualHosts."marduk.ru" = {
      root = "/srv/marduk.ru/public";

      locations = {
        "^~ /blog" = {
          extraConfig = ''
            try_files $uri @blog_cgi;
          '';
        };

        "@blog_cgi" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME /srv/marduk.ru/cgi-bin/blog.cgi;
            fastcgi_pass unix:/run/fcgiwrap/fcgiwrap.sock;
          '';
        };

        "/" = {
          extraConfig = ''
            try_files $uri @main_cgi;
          '';
        };

        "@main_cgi" = {
          extraConfig = ''
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME /srv/marduk.ru/cgi-bin/main.cgi;
            fastcgi_pass unix:/run/fcgiwrap/fcgiwrap.sock;
          '';
        };
      };

      extraConfig = ''
        # https://www.cloudflare.com/ips-v4
        allow 173.245.48.0/20;
        allow 103.21.244.0/22;
        allow 103.22.200.0/22;
        allow 103.31.4.0/22;
        allow 141.101.64.0/18;
        allow 108.162.192.0/18;
        allow 190.93.240.0/20;
        allow 188.114.96.0/20;
        allow 197.234.240.0/22;
        allow 198.41.128.0/17;
        allow 162.158.0.0/15;
        allow 104.16.0.0/13;
        allow 104.24.0.0/14;
        allow 172.64.0.0/13;
        allow 131.0.72.0/22;
        deny all;
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
