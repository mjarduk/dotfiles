{ pkgs, inputs, ... }: {
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      inputs.proton-ge.packages.${pkgs.system}.default
    ];
  };

  environment.systemPackages = with pkgs; [
    javaPackages.compiler.temurin-bin.jdk-21

    freecad
    mixxx
  ];
}
