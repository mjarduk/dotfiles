{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
