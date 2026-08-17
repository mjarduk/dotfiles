{ lib, config, ... }: {
  programs.zsh.shellAliases.switch =
    lib.mkForce "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/dots#marputer; omz reload";

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    XMODIFIER = "@im=fcitx5";
  };
}
