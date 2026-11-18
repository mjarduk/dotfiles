{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    opencode
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
