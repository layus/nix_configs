{ pkgs, config, ...}:
let 
  user = "user";

in {

  #config = {
    require = [
      <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
    ];

    /*
    system.build.customOVA = pkgs.lib.overrideDerivation config.system.build.virtualBoxOVA (oldAttrs: {
      postVM = ''
        set -x
        ${oldAttrs.postVM}

        VBoxManage sharedfolder add "$vmName" --name remote_folder --hostpath ./ --automount
      '';
    });
    */

    users.mutableUsers = false;
    users.users.root = {
      password = "root";
      openssh.authorizedKeys.keyFiles = [
        ~/.ssh/id_ecdsa.pub
      ];
    };
    users.users.${user} = {
      password = "";
      extraGroups = [ "vboxsf" ];
      isNormalUser = true;
    };

    environment.systemPackages = with pkgs; [
      emacs
      mozart
    ];

    virtualisation.virtualbox.guest.enable = true;

    #services.openssh.enable = true;

    boot.initrd.checkJournalingFS = false;

    services.xserver = {
      enable = true;
      displayManager.auto.enable = true;
      displayManager.auto.user = "${user}";
      #
      #windowManager.fluxbox.enable = true;
      #windowManager.default = "fluxbox";
      #windowManager.openbox.enable = true;
      #windowManager.default = "openbox";
      #
      desktopManager.xterm.enable = false;
      desktopManager.default = "";
      #desktopManager.lxqt.enable = true;
      #desktopManager.default = "lxqt";
    };

    # TODO
    # 1. user's /nix/var/nix/profiles/per-user/user is not defined.
    # 2. /tmp is not tmpfs and has missing write permissions (chmod a+wt /tmp).

    /* auto ?
    fileSystems."/home/${user}/shared_files" = {
      fsType = "vboxsf";
      device = "shared_files";
      options = [ "rw" ];
    };
    */ 
    
    fileSystems."/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };
  #};
}
