{ config, pkgs, ... }:
{

  ## Users

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  users.extraUsers = {
    layus = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keyFiles = [ /home/layus/.ssh/id_ecdsa.pub ];
    };

    deluge = {
      home = pkgs.lib.mkForce "/home/deluge";    # Use /home partition to store files.
      createHome = true;
    };
  };

  users.mutableUsers = false;


  ## Security
  
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    extraConfig = "Defaults:root,%wheel env_keep+=EDITOR";
  };


  ## Boot

  boot.cleanTmpDir = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };


  ## Nix

  nix.gc = {
    automatic = true;
    dates = "04:00";
  };

  nix.buildCores = 2;

  nix.maxJobs = 2;


  ## Systemd

  systemd.enableEmergencyMode = false;


  ## Services

  services.deluge.enable = true;
  services.deluge.web.enable = true;

  services.samba = {
    enable = true;
    configText = builtins.readFile ./smb.conf;
  };

  services.openssh = {
    enable = true;
    ports = [ 3248 ];
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  services.openvpn.servers = {
    server = {
      config = builtins.readFile ./openvpn-server.conf;
    };
    
    server-redirect = {
      config = builtins.readFile ./openvpn-server-redirect.conf;
    };
  };

  programs.zsh.enable = true;

  programs.bash.enableCompletion = true;

  ## Networking

  networking.hostName = "sto-lat";
  networking.domain = "no-ip.org";

  networking.firewall.allowedTCPPorts = [ 
    # ssh (auto)
    # samba (over vpn)
    8112  # deluge
    80    # http
  ];

  networking.firewall.allowedUDPPorts = [
    1194  # openvpn (redirect)
    1195  # openvpn
  ];

  networking.nat.internalIPs = [ "10.8.0.0/24" ];


  ## Environment

  time.timeZone = "Europe/Brussels";

  i18n = rec {
    consoleFont = "lat9w-16";
    consoleKeyMap = "be-latin1";
    defaultLocale = "en_GB.UTF-8";
    # Do not set, lest gcc (and everything else) is rebuilt.
    #supportedLocales = [ defaultLocale "fr_BE.UTF-8" ];
  };

  environment.variables = {
    LC_TIME = "fr_BE.UTF-8";
    LC_COLLATE = "fr_BE.UTF-8";
    EDITOR = "vim";
  };

  environment.systemPackages = with pkgs; [
    vim_configurable  # Decent file editor
    git               # Fetch configuration files
    vcsh              # Manage configuration files
    lynx              # Emergency web access
    htop atop         # List processes
  ];

  services.lighttpd = {
    enable = true;
    document-root = "/srv/http" ; # Serve the current directory

    mod_status = true;
    enableModules = [
      "mod_auth"  # Simple auth scheme
    ];
    extraConfig = ''
      dir-listing.activate = "enable"
      index-file.names = ( "index.html" )

      # Auth
      # Done in enableModules: server.modules += ( "mod_auth" )
      auth.debug = 2
      auth.backend = "plain"
      auth.backend.plain.userfile = "/etc/lighttpd/httppasswd"
      auth.require = (
        "/souad-et-antoine" => (
          "method" => "basic",
          "realm" => "Cet accès est protégé.",
          "require" => "user=souad"
        )
      )

      mimetype.assign += (
        # Web
        ".html" => "text/html",
        ".htm" => "text/html",
        ".txt" => "text/plain",
        ".css" => "text/css",
        ".js" => "application/x-javascript",
        # Pictures
        ".jpg" => "image/jpeg",
        ".jpeg" => "image/jpeg",
        ".gif" => "image/gif",
        ".png" => "image/png",
        # Videos
        ".mp4" => "video/mp4",
        ".webm" => "video/webm",
        ".ogv" => "video/ogg",
        # Default
        "" => "application/octet-stream"
      )
    ''; # services.lighttpd.extraConfig
  }; # services.lighttpd
}
