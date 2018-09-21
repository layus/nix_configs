{
  services.openssh.enable = true;
  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [
    /home/layus/.ssh/id_ecdsa.pub
  ];

  services.lighttpd.inginious = {
    enable = true;
    tasksDirectory = /home/layus/projects/INGInious/inginious/tasks ;
    superadmins = [ "gmaudoux" "layus" "test" ];
  };

  users.mutableUsers = false;
  users.extraUsers.root.extraGroups = [ "nogroup" ];

  services.mongodb.extraConfig = ''
    nojournal = true
  '';

  services.mopidy.enable = true;
  services.mopidy.configuration = "";

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 80 ];
  };
}
