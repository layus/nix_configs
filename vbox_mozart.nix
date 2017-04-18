{ pkgs, config, ...}:
let 
  user = "user";

in {

  require = [
    <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
  ];

  users.extraUsers.root.password = "root";
  users.extraUsers.${user}.password = "";

  environment.systemPackages = with pkgs; [
    mozart
  ];

  virtualisation.virtualbox.guest.enable = true;

  boot.initrd.checkJournalingFS = false;

  services.xserver.displayManager.auto.enable = true;
  services.xserver.displayManager.auto.user = "${user}";

  fileSystems."/home/${user}/shared_files" = {
    fsType = "vboxsf";
    device = "shared_files";
    options = [ "rw" ];
  };
}
