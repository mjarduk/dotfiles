{ pkgs, ... }: {
  users.users.minecraft = {
    isSystemUser = true;
    group = "minecraft";
  };
  users.groups.minecraft = {};

  systemd.tmpfiles.rules = [
    "d /srv/minecraft/zapusk 0744 minecraft minecraft -"
    "d /srv/minecraft/zapusk-2026-08/ 0744 minecraft minecraft -"
    "d /srv/minecraft/gtnh 0744 minecraft minecraft -"
    "d /run/marcraft 0750 minecraft minecraft -"
  ];

  networking.firewall.allowedUDPPorts = [ 24454 ];

  services.marcraft.zapusk = {
    enable = true;

    dataDir = "/srv/minecraft/zapusk-2026-08";
    javaPackage = pkgs.jdk25;
    jvmFlags = ["-XX:+UseZGC" "-XX:+UseCompactObjectHeaders" "-XX:+UseStringDeduplication" "-Xmx4G"];
    forgeArgsPath = "libraries/net/neoforged/neoforge/21.1.243/unix_args.txt";
    openFirewall = true;
  };

  services.marcraft.gtnh = {
    enable = false;

    dataDir = "/srv/minecraft/gtnh";
    javaPackage = pkgs.jdk25;
    jvmFlags = ["-XX:+UseZGC" "-XX:+UseCompactObjectHeaders" "-XX:+UseStringDeduplication" "-Xms6G" "-Xmx6G" "-Dfml.readTimeout=180" "@java9args.txt"];
    serverJar = "lwjgl3ify-forgePatches.jar";
    openFirewall = true;
  };
}
