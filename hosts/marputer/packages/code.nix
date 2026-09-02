{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    zed-editor
    uv
    rustup
    jetbrains.idea
    python314
  ];
}
