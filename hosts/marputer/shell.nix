{ lib, config, pkgs, ... }: {
  programs.zsh.shellAliases = {
    switch = lib.mkForce "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/dots#marputer; omz reload";
    cat = "bat -pp";
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    XMODIFIER = "@im=fcitx5";
  };

  services.udiskie = {
      enable = true;
      settings = {
          program_options = {
              # replace with your favorite file manager
              file_manager = "${pkgs.ranger}/bin/ranger";
          };
      };
  };
}
