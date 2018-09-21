{
  services.openssh.enable = true;
  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [
    /home/layus/.ssh/id_ecdsa.pub
  ];

  users.extraUsers.root.extraGroups = [ "nogroup" ];

  users.mutableUsers = false;
}
