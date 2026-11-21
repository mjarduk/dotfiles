{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    aseprite
    zed-editor
    uv
    jetbrains.idea
    jetbrains.rider
    python314
    gcc
    sbcl
    winbox4
    sing-box
    ghidra
    git-lfs

    ansible
    ansible-lint
    stack
    haskell-language-server
    openvpn
    pandoc
    gnumake
    file
    appimage-run
  ];

  programs.direnv.nix-direnv.enable = true;
  programs.bat.enable = true;
}
