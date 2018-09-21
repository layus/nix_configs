{ pkgs, config, ...}:
{
  services.openssh.enable = true;
  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [
    /home/layus/.ssh/id_ecdsa.pub
  ];

  services.mysql = {
    enable = true;
    package = pkgs.mysql;
  };

  services.httpd = {
    enable = true;
    adminAddr = "admin@example.org";
    extraSubservices =
      [ 
        {
          function = { ... }: {
            enablePHP = true;
            extraPath = [ pkgs.imagemagick ];
            documentRoot = /home/layus/projects/Lychee ;
          };
        }
      ];
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 80 ];
  };
}
