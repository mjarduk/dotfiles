{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    zed-editor
    uv
    rustup
    jetbrains.idea
    python314
    gcc
    sbcl
    winbox4

    ansible
    ansible-lint
    stack
    haskell-language-server
  ];

  programs.direnv.nix-direnv.enable = true;
  programs.bat.enable = true;
}
