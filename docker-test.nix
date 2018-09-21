{ config, pkgs, lib, ...}:

with lib;
{
  imports = [
    ./minimal.nix
  ];

  time.timeZone = "Europe/Brussels";
  environment.systemPackages = with pkgs; [ tree ]; 

  system.activationScripts = let none = { text = ""; deps = []; }; in {
    hostname = mkForce none;
    #nix = mkForce none;
    tmpfs = mkForce none;
    setuid = mkForce none;
    systemd = mkForce none;
    etc = mkForce none;
    users = mkForce none;
    specialfs = mkForce none;
    nix = mkForce none;
    polkit = mkForce none;
    var = mkForce none;
    wrappers = mkForce none;
  };

  boot.isContainer = true;

  system.build.bootStage2 = let 
    kernel = config.boot.kernelPackages.kernel;
    activateConfiguration = config.system.activationScripts.script;

  in pkgs.substituteAll {
    src = ./init.sh;
    shellDebug = "${pkgs.bashInteractive}/bin/bash";
    isExecutable = true;
    inherit (config.boot) devShmSize runSize;
    inherit (config.nix) readOnlyStore;
    inherit (config.networking) useHostResolvConf;
    ttyGid = config.ids.gids.tty;
    path =
      [ pkgs.coreutils
        pkgs.utillinux
        pkgs.openresolv
      ];
    postBootCommands = pkgs.writeText "local-cmds"
      ''
        ${config.boot.postBootCommands}
        ${config.powerManagement.powerUpCommands}
      '';
  };
}
