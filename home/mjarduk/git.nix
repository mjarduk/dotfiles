{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      core.excludesfile = "~/.gitignore";
      user.name = "mjarduk";
      user.email = "mjarduk@gmail.com";
      commit.gpgsign = true;
      user.signingKey = "BD5FBEE6E2C74D9487B442D4270C47FF55FB40C4";
    };
  };

  home.file = {
    ".gitignore" = {
      text = ''
        .DS_Store
      '';
    };
  };
}
