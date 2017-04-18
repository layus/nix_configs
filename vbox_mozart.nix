{ pkgs, config, ...}:
let 
  user = "user";

in {

  require = [
    <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
  ];

  users.mutableUsers = false;
  users.users.root = {
    password = "root";
    openssh.authorizedKeys.keyFiles = [
      ~/.ssh/id_ecdsa.pub
    ];
  };
  users.users.${user} = {
    password = "";
    isNormalUser = true;
  };

  environment.systemPackages = with pkgs; [
    emacs
    mozart
  ];

  virtualisation.virtualbox.guest.enable = true;

  services.openssh.enable = true;

  boot.initrd.checkJournalingFS = false;

  services.xserver = {
    enable = true;
    displayManager.auto.enable = true;
    displayManager.auto.user = "${user}";
    windowManager.i3.enable = true;
    windowManager.default = "i3";
    desktopManager.default = "xterm";
  };

  # TODO
  # 1. user's /nix/var/nix/profiles/per-user/user is not defined.
  # 2. /tmp is not tmpfs and has missing write permissions (chmod a+wt /tmp).

  /*
  fileSystems."/home/${user}/shared_files" = {
    fsType = "vboxsf";
    device = "shared_files";
    options = [ "rw" ];
  };
  */
}
