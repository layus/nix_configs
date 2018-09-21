{
  services.openssh.enable = true;
  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [
    /home/layus/.ssh/id_ecdsa.pub
  ];

  services.xserver.windowManager.windowmaker.enable = true;
}
