{pkgs, ...}:
{
    imports = [ ./minimal.nix ./mptcp.nix ];

    networking.hostName = "inginious-webserver";
    time.timeZone = "Europe/Brussels";

    services.lighttpd.inginious = {
      enable = true;
      superadmins = [ "gmaudoux" ];
      containers = {
        default = "ingi/inginious-c-default";
        oz      = "ingi/inginious-c-oz";
      };

      extraConfig = ''
        plugins:
          - plugin_module: inginious.frontend.webapp.plugins.auth.demo_auth
            users:
              gmaudoux: gmaudoux
      '';
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 ];
    };

    # This is a small server
    services.mongodb.extraConfig = ''
      smallfiles = true
      nojournal = true
    '';

    # but docker needs more space !
    virtualisation.diskSize = 2048; #MiB

    nixpkgs.config.packageOverrides = (oldPkgs: {
      inginious = oldPkgs.inginious.overrideDerivation (oldAttrs: {
        src = /home/layus/projects/INGInious;
      });
    });
      
}
