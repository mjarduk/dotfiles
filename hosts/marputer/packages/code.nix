{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    aseprite
    zed-editor
    uv
    jetbrains.idea
    python314
    gcc
    sbcl
    winbox4
    sing-box
    ghidra

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
