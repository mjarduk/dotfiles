{ self, pkgs, home-manager, inputs, ... }:
{
  imports = [
    home-manager.darwinModules.home-manager
    ./packages.nix
  ];

  home-manager.users.mjarduk = import ../../home/mjarduk;
  home-manager.backupFileExtension = ".bak";
  home-manager.extraSpecialArgs = {
    username = "mjarduk";
    homeDirectory = "/Users/mjarduk";
    inherit inputs;
  };

  environment.systemPackages = with pkgs; [
    vim
    smartmontools
    python3
    git
  ];

  nix = {
    settings = {
      max-jobs = "auto";
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };

    gc = {
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 0;
      };

      options = "--delete-older-than 3d";
    };
  };

  users.users.mjarduk = {
    name = "mjarduk";
    home = "/Users/mjarduk";
  };

  networking.hostName = "marbook";
  networking.computerName = "marbook";

  system.stateVersion = 6;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.primaryUser = "mjarduk";

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
