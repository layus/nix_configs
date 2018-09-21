{pkgs, lib, ...}:
{
  # Allow ssh
  services.openssh.enable = true;

  # Setup ssh key for root
  users.mutableUsers = false;
  users.extraUsers.root.password = "root";
  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [
    ~/.ssh/id_ecdsa.pub
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = "/var/run/current-system/sw/bin/zsh";

  # Disable X libs as this is a headless server
  environment.noXlibs = lib.mkDefault true;

  environment.systemPackages = [ pkgs.rxvt_unicode.terminfo ];

  # Define keymap for Qemu
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "be-latin1";
    defaultLocale = "en_US.UTF-8";
  };
}

