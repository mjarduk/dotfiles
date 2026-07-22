{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    android-tools
    colima
    docker
    duti
    ghostty-bin
    gnupg
    keepassxc
    nodejs
    qbittorrent-enhanced
    obsidian
    syncthing-macos
    utm
    vlc-bin
    xld
    zed-editor
  ];

  homebrew = {
    enable = true;
    brews = [
      "audacious"
      "ghidra"
      "ocp"
      "omlx"
      "openssh"
      "ykman"
      "libfido2"
    ];
    casks = [
      "winbox"
      "vesktop"
      "anki"
      "prismlauncher"
      "milkytracker"
    ];

    taps = [
      {
        name = "jundot/omlx";
        clone_target = "https://github.com/jundot/omlx";
      }
    ];
  };
}
